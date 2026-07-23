import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/partner_applications_repository.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/screens/partner_application_success_screen.dart';
import 'package:address/features/partners/presentation/localization/partner_localizations.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class PartnerApplicationReviewScreen extends StatefulWidget {
  const PartnerApplicationReviewScreen({required this.draft, super.key});

  final PartnerRegistrationDraft draft;

  @override
  State<PartnerApplicationReviewScreen> createState() =>
      _PartnerApplicationReviewScreenState();
}

class _PartnerApplicationReviewScreenState
    extends State<PartnerApplicationReviewScreen> {
  late final PartnerApplicationsRepository _repository;
  late final String _clientRequestId;

  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _repository = PartnerApplicationsRepository();
    _clientRequestId = _repository.createClientRequestId();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final draft = widget.draft;

    return AppPageScaffold(
      navigationIcon: Icons.arrow_back_ios_new_rounded,
      navigationLabel: localizations.partnersBack,
      onNavigationPressed: () => context.pop(),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppLayoutTokens.screenHorizontalPadding,
            AppSpacingTokens.small,
            AppLayoutTokens.screenHorizontalPadding,
            AppSpacingTokens.medium,
          ),
          child: Center(
            child: AnimatedStartButton(
              title: localizations.partnerApplicationSubmitFinal,
              isEnabled: !_isSubmitting,
              isLoading: _isSubmitting,
              onTap: _submit,
            ),
          ),
        ),
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.contentMaxWidth,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppLayoutTokens.screenHorizontalPadding,
              AppSpacingTokens.small,
              AppLayoutTokens.screenHorizontalPadding,
              AppSpacingTokens.xxLarge,
            ),
            children: <Widget>[
              Text(
                localizations.partnerApplicationReviewTitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.small),
              Text(
                localizations.partnerApplicationReviewSubtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              if (_errorMessage != null) ...<Widget>[
                const SizedBox(height: AppSpacingTokens.medium),
                _ErrorBanner(message: _errorMessage!),
              ],
              const SizedBox(height: AppSpacingTokens.large),
              _ReviewSection(
                title: localizations.partnerApplicationActivitySection,
                icon: Icons.category_rounded,
                rows: <_ReviewRow>[
                  _ReviewRow(
                    label: localizations.partnerApplicationCategory,
                    value: draft.selection.categoryId.title(localizations),
                  ),
                  _ReviewRow(
                    label: localizations.partnerApplicationApplicantType,
                    value:
                        draft.applicantType == PartnerApplicantType.legalEntity
                        ? localizations.partnerRegistrationLegalEntity
                        : localizations.partnerRegistrationIndividual,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              _ReviewSection(
                title: localizations.partnerApplicationIdentitySection,
                icon: Icons.badge_rounded,
                rows: <_ReviewRow>[
                  _ReviewRow(
                    label: localizations.partnerApplicationApplicantName,
                    value:
                        draft.applicantType == PartnerApplicantType.legalEntity
                        ? draft.representativeName
                        : draft.fullName,
                  ),
                  _ReviewRow(
                    label: localizations.partnerRegistrationMobile,
                    value: draft.mobile,
                  ),
                  if (draft.applicantType == PartnerApplicantType.legalEntity)
                    _ReviewRow(
                      label: localizations.partnerRegistrationCompanyName,
                      value: draft.companyName,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              _ReviewSection(
                title: localizations.partnerApplicationStoreSection,
                icon: Icons.storefront_rounded,
                rows: <_ReviewRow>[
                  _ReviewRow(
                    label: localizations.partnerRegistrationStoreName,
                    value: draft.storeName,
                  ),
                  _ReviewRow(
                    label: localizations.partnerRegistrationPostalCode,
                    value: draft.postalCode,
                  ),
                  _ReviewRow(
                    label: localizations.partnerRegistrationStoreAddress,
                    value: draft.storeAddress,
                  ),
                  _ReviewRow(
                    label: localizations.partnerApplicationMapStatus,
                    value: draft.mapConfirmed
                        ? localizations.partnerApplicationMapConfirmed
                        : localizations.partnerApplicationMapNotConfirmed,
                  ),
                ],
              ),
              const SizedBox(height: AppSpacingTokens.medium),
              _ReviewSection(
                title: localizations.partnerApplicationDocumentsSection,
                icon: Icons.folder_copy_rounded,
                rows: <_ReviewRow>[
                  _ReviewRow(
                    label: localizations.partnerRegistrationNationalId,
                    value: localizations.partnerApplicationVerified,
                  ),
                  _ReviewRow(
                    label: localizations.partnerLivenessTitle,
                    value: localizations.partnerApplicationVerified,
                  ),
                  _ReviewRow(
                    label: localizations.partnerRegistrationSignboardImage,
                    value: draft.signboardImageName,
                  ),
                  _ReviewRow(
                    label: localizations.partnerOwnershipDocumentImage,
                    value: draft.ownershipDocumentImageName,
                  ),
                  if (draft.licenseImageName.isNotEmpty)
                    _ReviewRow(
                      label: localizations.partnerRegistrationLicenseImage,
                      value: draft.licenseImageName,
                    ),
                ],
              ),
              const SizedBox(height: AppSpacingTokens.large),
              Text(
                localizations.partnerApplicationSubmissionNotice,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacingTokens.xxLarge),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) {
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final result = await _repository.submit(
        draft: widget.draft,
        clientRequestId: _clientRequestId,
      );

      if (!mounted) {
        return;
      }

      context.go(
        AppRoutePaths.partnerApplicationSuccess,
        extra: PartnerApplicationSuccessArgs(
          application: result.application,
          idempotent: result.idempotent,
        ),
      );
    } on PartnerApplicationException catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.message;
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }
}

class _ReviewSection extends StatelessWidget {
  const _ReviewSection({
    required this.title,
    required this.icon,
    required this.rows,
  });

  final String title;
  final IconData icon;
  final List<_ReviewRow> rows;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Icon(icon, color: colors.primary),
                const SizedBox(width: AppSpacingTokens.small),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacingTokens.medium),
            for (var index = 0; index < rows.length; index++) ...<Widget>[
              _ReviewRowView(row: rows[index]),
              if (index != rows.length - 1)
                const Divider(height: AppSpacingTokens.large),
            ],
          ],
        ),
      ),
    );
  }
}

class _ReviewRow {
  const _ReviewRow({required this.label, required this.value});

  final String label;
  final String value;
}

class _ReviewRowView extends StatelessWidget {
  const _ReviewRowView({required this.row});

  final _ReviewRow row;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          flex: 2,
          child: Text(
            row.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: AppSpacingTokens.medium),
        Expanded(
          flex: 3,
          child: Text(
            row.value.trim().isEmpty ? '—' : row.value,
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

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
