import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/core/utils/persian_date_formatter.dart';
import 'package:address/features/partner_registration/data/models/partner_application.dart';
import 'package:address/features/partner_registration/data/partner_applications_repository.dart';
import 'package:address/features/partner_registration/domain/models/partner_correction_item.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/localization/partner_application_localizations.dart';
import 'package:address/l10n/generated/app_localizations.dart';

// addressPartnerSelectiveCorrectionV1
class PartnerApplicationDetailsScreen extends StatefulWidget {
  const PartnerApplicationDetailsScreen({
    required this.applicationId,
    super.key,
  });

  final String applicationId;

  @override
  State<PartnerApplicationDetailsScreen> createState() =>
      _PartnerApplicationDetailsScreenState();
}

class _PartnerApplicationDetailsScreenState
    extends State<PartnerApplicationDetailsScreen>
    with WidgetsBindingObserver {
  static const Duration _refreshInterval = Duration(seconds: 25);

  late final PartnerApplicationsRepository _repository;

  Timer? _refreshTimer;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  PartnerApplicationDetails? _details;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _repository = PartnerApplicationsRepository();
    unawaited(_load(showLoading: true));
    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      if (!mounted ||
          _isRefreshing ||
          ModalRoute.of(context)?.isCurrent != true) {
        return;
      }

      unawaited(_load(showLoading: false));
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        mounted &&
        ModalRoute.of(context)?.isCurrent == true) {
      unawaited(_load(showLoading: false));
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppPageScaffold(
      navigationIcon: Icons.arrow_back_ios_new_rounded,
      navigationLabel: localizations.partnersBack,
      onNavigationPressed: () => context.pop(),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.contentMaxWidth,
          ),
          child: RefreshIndicator(
            onRefresh: () => _load(showLoading: false),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppLayoutTokens.screenHorizontalPadding,
                AppSpacingTokens.small,
                AppLayoutTokens.screenHorizontalPadding,
                AppSpacingTokens.xxLarge,
              ),
              children: <Widget>[
                Text(
                  localizations.partnerApplicationDetailsTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.large),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(AppSpacingTokens.xxLarge),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_errorMessage != null && _details == null)
                  Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacingTokens.large),
                      child: Column(
                        children: <Widget>[
                          Text(_errorMessage!, textAlign: TextAlign.center),
                          const SizedBox(height: AppSpacingTokens.medium),
                          OutlinedButton.icon(
                            onPressed: () => _load(showLoading: true),
                            icon: const Icon(Icons.refresh_rounded),
                            label: Text(localizations.partnerApplicationRetry),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (_details != null) ...<Widget>[
                  if (_errorMessage != null) ...<Widget>[
                    _RefreshWarning(message: _errorMessage!),
                    const SizedBox(height: AppSpacingTokens.medium),
                  ],
                  _SummaryCard(details: _details!),
                  if (_details!.summary.status ==
                      PartnerApplicationStatus.needsCorrection) ...<Widget>[
                    const SizedBox(height: AppSpacingTokens.medium),
                    _CorrectionCard(
                      details: _details!,
                      onStartCorrection: _startCorrection,
                    ),
                  ],
                  const SizedBox(height: AppSpacingTokens.medium),
                  _HistoryCard(details: _details!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _startCorrection() {
    final details = _details;
    if (details == null) {
      return;
    }

    final correctionItems = details.latestCorrectionItems;

    if (correctionItems.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(
                context,
              ).partnerSelectiveCorrectionItemsUnavailable,
            ),
          ),
        );
      return;
    }

    final draft = PartnerRegistrationDraft.fromApplicationSnapshot(
      snapshot: details.snapshot,
      applicationId: details.summary.id,
      revision: details.summary.revision,
      correctionNote: details.latestCorrectionNote ?? '',
      correctionItems: correctionItems,
    );

    context.push(AppRoutePaths.partnerApplicationCorrection, extra: draft);
  }

  Future<void> _load({required bool showLoading}) async {
    if (_isRefreshing) {
      return;
    }

    _isRefreshing = true;

    if (mounted && showLoading) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }

    try {
      final details = await _repository.findOne(
        applicationId: widget.applicationId,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _details = details;
        _isLoading = false;
        _errorMessage = null;
      });
    } on PartnerApplicationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.message;
        _isLoading = false;
      });
    } finally {
      _isRefreshing = false;
    }
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.details});

  final PartnerApplicationDetails details;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final summary = details.summary;
    final formattedDate = PersianDateFormatter.format(summary.submittedAt);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              localizations.partnerApplicationTrackingCode,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacingTokens.small),
            Directionality(
              textDirection: TextDirection.ltr,
              child: SelectableText(
                summary.trackingCode,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
              ),
            ),
            const Divider(height: AppSpacingTokens.xLarge),
            _DetailRow(
              label: localizations.partnerApplicationCurrentStatus,
              value: summary.status.title(localizations),
            ),
            const SizedBox(height: AppSpacingTokens.small),
            _DetailRow(
              label: localizations.partnerApplicationSubmittedAt,
              value: formattedDate,
            ),
            const SizedBox(height: AppSpacingTokens.small),
            _DetailRow(
              label: localizations.partnerApplicationRevision,
              value: summary.revision.toString(),
            ),
          ],
        ),
      ),
    );
  }
}

class _CorrectionCard extends StatelessWidget {
  const _CorrectionCard({
    required this.details,
    required this.onStartCorrection,
  });

  final PartnerApplicationDetails details;
  final VoidCallback onStartCorrection;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final note = details.latestCorrectionNote;
    final items = details.latestCorrectionItems;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(
                  Icons.rule_folder_rounded,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(width: AppSpacingTokens.small),
                Expanded(
                  child: Text(
                    localizations.partnerApplicationCorrectionTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacingTokens.medium),
            Text(
              localizations.partnerSelectiveCorrectionOnlySelected,
              style: const TextStyle(height: 1.6),
            ),
            if (items.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacingTokens.medium),
              for (var index = 0; index < items.length; index++) ...<Widget>[
                _CorrectionItemRow(item: items[index]),
                if (index != items.length - 1)
                  const Divider(height: AppSpacingTokens.large),
              ],
            ],
            if (note != null && note.isNotEmpty) ...<Widget>[
              const SizedBox(height: AppSpacingTokens.medium),
              Text(
                localizations.partnerApplicationCorrectionNoteTitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.xSmall),
              Text(
                note,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  height: 1.6,
                ),
              ),
            ],
            const SizedBox(height: AppSpacingTokens.large),
            Center(
              child: AnimatedStartButton(
                title: localizations.partnerApplicationStartCorrection,
                onTap: onStartCorrection,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CorrectionItemRow extends StatelessWidget {
  const _CorrectionItemRow({required this.item});

  final PartnerCorrectionItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Icon(
            Icons.check_circle_rounded,
            size: 19,
            color: Theme.of(context).colorScheme.error,
          ),
        ),
        const SizedBox(width: AppSpacingTokens.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                item.title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              if (item.note != null) ...<Widget>[
                const SizedBox(height: 3),
                Text(item.note!, style: const TextStyle(height: 1.5)),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.details});

  final PartnerApplicationDetails details;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final history = details.statusHistory;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              localizations.partnerApplicationStatusHistory,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacingTokens.medium),
            if (history.isEmpty)
              Text(localizations.partnerApplicationNoStatusHistory)
            else
              for (var index = 0; index < history.length; index++) ...<Widget>[
                _HistoryEntry(entry: history[index]),
                if (index != history.length - 1)
                  const Divider(height: AppSpacingTokens.large),
              ],
          ],
        ),
      ),
    );
  }
}

class _HistoryEntry extends StatelessWidget {
  const _HistoryEntry({required this.entry});

  final PartnerApplicationStatusEntry entry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final formattedDate = PersianDateFormatter.format(entry.createdAt);
    final historyMessage = entry.localizedMessage(localizations);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Icon(
            Icons.circle,
            size: 12,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: AppSpacingTokens.small),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                entry.status.title(localizations),
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(formattedDate, style: Theme.of(context).textTheme.bodySmall),
              if (historyMessage != null) ...<Widget>[
                const SizedBox(height: 4),
                Text(historyMessage, style: const TextStyle(height: 1.5)),
              ],
              if (entry.correctionItems.isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacingTokens.small),
                for (final item in entry.correctionItems)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '• ${item.title}'
                      '${item.note == null ? '' : ': ${item.note}'}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacingTokens.medium),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
      ],
    );
  }
}

class _RefreshWarning extends StatelessWidget {
  const _RefreshWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacingTokens.medium),
      decoration: BoxDecoration(
        color: colors.errorContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: colors.onErrorContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
