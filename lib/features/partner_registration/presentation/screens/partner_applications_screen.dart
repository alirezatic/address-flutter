import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/core/utils/persian_date_formatter.dart';
import 'package:address/features/partner_registration/data/models/partner_application.dart';
import 'package:address/features/partner_registration/data/partner_applications_repository.dart';
import 'package:address/features/partner_registration/presentation/localization/partner_application_localizations.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partners/presentation/localization/partner_localizations.dart';
import 'package:address/l10n/generated/app_localizations.dart';

// addressPartnerSelectiveCorrectionV1
class PartnerApplicationsScreenArgs {
  const PartnerApplicationsScreenArgs({
    required this.application,
    required this.idempotent,
    this.resubmitted = false,
  });

  final PartnerApplicationSummary application;
  final bool idempotent;
  final bool resubmitted;
}

class PartnerApplicationsScreen extends StatefulWidget {
  const PartnerApplicationsScreen({this.args, super.key});

  final PartnerApplicationsScreenArgs? args;

  @override
  State<PartnerApplicationsScreen> createState() =>
      _PartnerApplicationsScreenState();
}

class _PartnerApplicationsScreenState extends State<PartnerApplicationsScreen>
    with WidgetsBindingObserver {
  static const Duration _refreshInterval = Duration(seconds: 25);

  late final PartnerApplicationsRepository _repository;

  Timer? _refreshTimer;
  bool _isLoading = true;
  bool _isRefreshing = false;
  String? _errorMessage;
  List<PartnerApplicationSummary> _applications =
      const <PartnerApplicationSummary>[];

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

    if (widget.args != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSubmissionResult(widget.args!);
      });
    }
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

  void _showSubmissionResult(PartnerApplicationsScreenArgs args) {
    if (!mounted) {
      return;
    }

    final localizations = AppLocalizations.of(context);
    final message = args.resubmitted
        ? localizations.partnerApplicationResubmittedMessage
        : args.idempotent
        ? localizations.partnerApplicationAlreadySubmittedMessage
        : localizations.partnerApplicationSuccessMessage;
    final trackingCode =
        '${localizations.partnerApplicationTrackingCode}: '
        '${args.application.trackingCode}';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('$message\n$trackingCode'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 7),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppPageScaffold(
      navigationIcon: Icons.arrow_back_ios_new_rounded,
      navigationLabel: localizations.partnersBack,
      onNavigationPressed: () {
        if (context.canPop()) {
          context.pop();
          return;
        }

        context.go(AppRoutePaths.addressPartners);
      },
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
                  localizations.partnerApplicationsTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.small),
                Text(
                  localizations.partnerApplicationsSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.large),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(AppSpacingTokens.xxLarge),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_errorMessage != null && _applications.isEmpty)
                  _ApplicationsMessageCard(
                    icon: Icons.cloud_off_rounded,
                    message: _errorMessage!,
                    actionLabel: localizations.partnerApplicationRetry,
                    onAction: () => _load(showLoading: true),
                  )
                else ...<Widget>[
                  if (_errorMessage != null) ...<Widget>[
                    _ApplicationsMessageCard(
                      icon: Icons.sync_problem_rounded,
                      message: _errorMessage!,
                      actionLabel: localizations.partnerApplicationRetry,
                      onAction: () => _load(showLoading: false),
                    ),
                    const SizedBox(height: AppSpacingTokens.medium),
                  ],
                  if (_applications.isEmpty)
                    _ApplicationsMessageCard(
                      icon: Icons.inbox_rounded,
                      message: localizations.partnerApplicationsEmpty,
                    )
                  else
                    for (
                      var index = 0;
                      index < _applications.length;
                      index++
                    ) ...<Widget>[
                      _ApplicationCard(
                        application: _applications[index],
                        onTap: () async {
                          await context.push(
                            AppRoutePaths.partnerApplicationDetailsLocation(
                              _applications[index].id,
                            ),
                          );

                          if (mounted) {
                            unawaited(_load(showLoading: false));
                          }
                        },
                      ),
                      if (index != _applications.length - 1)
                        const SizedBox(height: AppSpacingTokens.medium),
                    ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
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
      final applications = await _repository.findMine();

      if (!mounted) {
        return;
      }

      setState(() {
        _applications = applications;
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

class _ApplicationCard extends StatelessWidget {
  const _ApplicationCard({required this.application, required this.onTap});

  final PartnerApplicationSummary application;
  final VoidCallback onTap;

  Color _statusShadowColor() {
    return switch (application.status) {
      PartnerApplicationStatus.submitted => const Color(0xFF1565C0),
      PartnerApplicationStatus.underReview => const Color(0xFFF9A825),
      PartnerApplicationStatus.needsCorrection => const Color(0xFFEF6C00),
      PartnerApplicationStatus.rejected => const Color(0xFFC62828),
      PartnerApplicationStatus.approved => const Color(0xFF2E7D32),
      PartnerApplicationStatus.unknown => const Color(0xFF616161),
    };
  }

  String _activityTitle(AppLocalizations localizations) {
    final rawIds = <String>[
      if (application.primaryItemId != null) application.primaryItemId!,
      ...application.selectedItemIds,
    ];
    final activities = <PartnerItemId>[];

    for (final rawId in rawIds) {
      for (final item in PartnerItemId.values) {
        if (item.name == rawId && !activities.contains(item)) {
          activities.add(item);
          break;
        }
      }
    }

    if (activities.isNotEmpty) {
      return activities.map((item) => item.title(localizations)).join('ØŒ ');
    }

    final category = PartnerCategoryId.tryParse(application.categoryId);

    return category?.title(localizations) ?? application.categoryId.trim();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final formattedDate = PersianDateFormatter.format(application.submittedAt);
    final activityTitle = _activityTitle(localizations);
    final storeName = application.storeName.trim().isEmpty
        ? 'â€”'
        : application.storeName.trim();
    final statusShadowColor = _statusShadowColor();

    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      shadowColor: statusShadowColor.withValues(alpha: 0.58),
      elevation: 9,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacingTokens.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.assignment_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: AppSpacingTokens.small),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Text(
                        application.trackingCode,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              _ApplicationInfoRow(
                icon: Icons.category_rounded,
                label: localizations.partnerApplicationActivitySection,
                value: activityTitle,
              ),
              const SizedBox(height: AppSpacingTokens.small),
              _ApplicationInfoRow(
                icon: Icons.storefront_rounded,
                label: localizations.partnerRegistrationStoreName,
                value: storeName,
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              Wrap(
                spacing: AppSpacingTokens.small,
                runSpacing: AppSpacingTokens.small,
                children: <Widget>[
                  _StatusChip(
                    label: application.status.title(localizations),
                    status: application.status,
                  ),
                  Chip(
                    avatar: const Icon(Icons.schedule_rounded, size: 18),
                    label: Text(formattedDate),
                  ),
                  Chip(
                    avatar: const Icon(Icons.history_rounded, size: 18),
                    label: Text(
                      '${localizations.partnerApplicationRevision}: '
                      '${application.revision}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ApplicationInfoRow extends StatelessWidget {
  const _ApplicationInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, size: 20, color: colors.primary),
        const SizedBox(width: AppSpacingTokens.small),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: '$label: ',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                TextSpan(text: value),
              ],
            ),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
              color: colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.status});

  final String label;
  final PartnerApplicationStatus status;

  Color _statusColor() {
    return switch (status) {
      PartnerApplicationStatus.submitted => const Color(0xFF1565C0),
      PartnerApplicationStatus.underReview => const Color(0xFFF9A825),
      PartnerApplicationStatus.needsCorrection => const Color(0xFFEF6C00),
      PartnerApplicationStatus.rejected => const Color(0xFFC62828),
      PartnerApplicationStatus.approved => const Color(0xFF2E7D32),
      PartnerApplicationStatus.unknown => const Color(0xFF616161),
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = _statusColor();

    return Chip(
      backgroundColor: Colors.white,
      shadowColor: color.withValues(alpha: 0.68),
      elevation: 7,
      avatar: Icon(Icons.circle, size: 12, color: color),
      label: Text(label),
    );
  }
}

class _ApplicationsMessageCard extends StatelessWidget {
  const _ApplicationsMessageCard({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.xLarge),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 52, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacingTokens.medium),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.5),
            ),
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: AppSpacingTokens.medium),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
