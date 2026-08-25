import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/buttons/animated_start_button.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/partner_registration/data/partner_verification_repository.dart';
import 'package:address/features/partner_registration/domain/models/partner_registration_draft.dart';
import 'package:address/features/partner_registration/presentation/controller/partner_registration_start_coordinator.dart';
import 'package:address/features/partners/data/partner_catalog.dart';
import 'package:address/features/partners/domain/models/partner_category.dart';
import 'package:address/features/partners/presentation/localization/partner_localizations.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class AddressPartnersScreen extends StatefulWidget {
  const AddressPartnersScreen({super.key});

  @override
  State<AddressPartnersScreen> createState() => _AddressPartnersScreenState();
}

class _AddressPartnersScreenState extends State<AddressPartnersScreen> {
  PartnerApplicantType? _applicantType;
  PartnerCategoryId? _selectedCategoryId;
  PartnerItemId? _selectedItemId;

  bool _isNavigating = false;

  bool get _canContinue =>
      _applicantType != null &&
      _selectedCategoryId != null &&
      _selectedItemId != null &&
      !_isNavigating;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return AppPageScaffold(
      navigationIcon: Icons.home_rounded,
      navigationLabel: localizations.home,
      onNavigationPressed: () => context.go(AppRoutePaths.home),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.compactContentMaxWidth,
          ),
          child: ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              AppLayoutTokens.screenHorizontalPadding,
              0,
              AppLayoutTokens.screenHorizontalPadding,
              AppSpacingTokens.xxLarge,
            ),
            children: <Widget>[
              // عنوان صفحه - دقیقاً هم‌سبک سایر صفحات ثبت‌نام
              Text(
                localizations.partnersBrandTitle,
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: colors.onSurface,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: AppSpacingTokens.large),

              // نوع متقاضی - دو دکمه ثابت و سفید
              Row(
                children: <Widget>[
                  Expanded(
                    child: _ApplicantTypeButton(
                      title: _applicantLabel(
                        localizations,
                        PartnerApplicantType.individual,
                      ),
                      icon: Icons.person_rounded,
                      isSelected:
                          _applicantType == PartnerApplicantType.individual,
                      onTap: _isNavigating
                          ? null
                          : () {
                              setState(() {
                                _applicantType =
                                    PartnerApplicantType.individual;
                              });
                            },
                    ),
                  ),
                  const SizedBox(width: AppSpacingTokens.small),
                  Expanded(
                    child: _ApplicantTypeButton(
                      title: _applicantLabel(
                        localizations,
                        PartnerApplicantType.legalEntity,
                      ),
                      icon: Icons.business_rounded,
                      isSelected:
                          _applicantType == PartnerApplicantType.legalEntity,
                      onTap: _isNavigating
                          ? null
                          : () {
                              setState(() {
                                _applicantType =
                                    PartnerApplicantType.legalEntity;
                              });
                            },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacingTokens.medium),

              // زمینه همکاری
              _SectionCard(
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacingTokens.medium,
                    vertical: AppSpacingTokens.xSmall,
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(
                    AppSpacingTokens.small,
                    AppSpacingTokens.small,
                    AppSpacingTokens.small,
                    AppSpacingTokens.medium,
                  ),
                  shape: const Border(),
                  collapsedShape: const Border(),
                  title: Text(
                    'زمینه همکاری',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  subtitle: _selectedItemId == null
                      ? null
                      : Text(
                          _selectedItemId!.title(localizations),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                  children: <Widget>[
                    for (final category in PartnerCatalog.categories)
                      _CategoryExpansion(
                        category: category,
                        selectedItemId: _selectedItemId,
                        isEnabled: !_isNavigating,
                        onSelected: (itemId) {
                          setState(() {
                            _selectedCategoryId = category.id;
                            _selectedItemId = itemId;
                          });
                        },
                      ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacingTokens.xxLarge),

              // دقیقاً مشابه سایر صفحات ثبت‌نام:
              // دکمه به اندازه طبیعی خودش و در مرکز
              Center(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: AnimatedStartButton(
                    title: 'ادامه',
                    icon: Icons.arrow_forward_rounded,
                    isLoading: _isNavigating,
                    isEnabled: _canContinue,
                    onTap: _continueRegistration,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _continueRegistration() async {
    if (!_canContinue) {
      return;
    }

    final applicantType = _applicantType;
    final categoryId = _selectedCategoryId;
    final itemId = _selectedItemId;

    if (applicantType == null || categoryId == null || itemId == null) {
      return;
    }

    setState(() {
      _isNavigating = true;
    });

    final category = PartnerCatalog.byId(categoryId);

    final selection = PartnerSelectionResult(
      categoryId: categoryId,
      driverMode: applicantType == PartnerApplicantType.legalEntity
          ? PartnerDriverMode.company
          : PartnerDriverMode.personal,
      primaryItemId:
          category.selectionMode == PartnerSelectionMode.primarySecondary
          ? itemId
          : null,
      selectedItemIds:
          category.selectionMode == PartnerSelectionMode.primarySecondary
          ? const <PartnerItemId>{}
          : <PartnerItemId>{itemId},
    );

    try {
      await PartnerRegistrationStartCoordinator.open(
        context: context,
        selection: selection,
        applicantType: applicantType,
      );
    } on PartnerVerificationException catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(error.message),
            behavior: SnackBarBehavior.floating,
          ),
        );
    } finally {
      if (mounted) {
        setState(() {
          _isNavigating = false;
        });
      }
    }
  }
}

class _ApplicantTypeButton extends StatelessWidget {
  const _ApplicantTypeButton({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final foregroundColor = isSelected ? colors.primary : colors.onSurface;

    return Material(
      // در هر دو حالت سفید باقی می‌ماند
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 54,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacingTokens.medium,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? colors.primary
                  : colors.outlineVariant.withValues(alpha: 0.75),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? <BoxShadow>[
                    BoxShadow(
                      color: colors.primary.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 21, color: foregroundColor),
              const SizedBox(width: AppSpacingTokens.small),
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: foregroundColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: ClipRRect(borderRadius: BorderRadius.circular(18), child: child),
    );
  }
}

class _CategoryExpansion extends StatelessWidget {
  const _CategoryExpansion({
    required this.category,
    required this.selectedItemId,
    required this.isEnabled,
    required this.onSelected,
  });

  final PartnerCategoryDefinition category;
  final PartnerItemId? selectedItemId;
  final bool isEnabled;
  final ValueChanged<PartnerItemId> onSelected;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final accent = _categoryAccent(category.id);

    final selectedInCategory = category.items.any(
      (item) => item.id == selectedItemId,
    );

    final backgroundColor = Color.alphaBlend(
      accent.withValues(alpha: selectedInCategory ? 0.18 : 0.09),
      colors.surface,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacingTokens.small),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accent.withValues(alpha: selectedInCategory ? 0.60 : 0.32),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ExpansionTile(
          backgroundColor: backgroundColor,
          collapsedBackgroundColor: backgroundColor,
          tilePadding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacingTokens.small,
            AppSpacingTokens.xSmall,
            AppSpacingTokens.medium,
            AppSpacingTokens.xSmall,
          ),
          childrenPadding: EdgeInsets.zero,
          shape: const Border(),
          collapsedShape: const Border(),

          leading: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              category.imagePath,
              width: 46,
              height: 46,
              fit: BoxFit.cover,
            ),
          ),

          // تمام عنوان‌های گروه‌ها یک اندازه و یک وزن
          title: Text(
            category.id.title(localizations),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              color: accent,
              fontWeight: FontWeight.w800,
            ),
          ),

          subtitle: selectedInCategory && selectedItemId != null
              ? Text(
                  selectedItemId!.title(localizations),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accent,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Text(
                  category.id.subtitle(localizations),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),

          children: <Widget>[
            Container(
              width: double.infinity,
              color: colors.surface,
              child: IgnorePointer(
                ignoring: !isEnabled,
                child: RadioGroup<PartnerItemId>(
                  groupValue: selectedItemId,
                  onChanged: (value) {
                    if (value != null) {
                      onSelected(value);
                    }
                  },
                  child: Column(
                    children: <Widget>[
                      for (
                        var index = 0;
                        index < category.items.length;
                        index++
                      ) ...<Widget>[
                        RadioListTile<PartnerItemId>(
                          value: category.items[index].id,

                          // در RTL دایره در سمت مقابل متن یعنی سمت چپ
                          controlAffinity: ListTileControlAffinity.trailing,

                          activeColor: accent,

                          contentPadding: const EdgeInsetsDirectional.fromSTEB(
                            AppSpacingTokens.medium,
                            AppSpacingTokens.xSmall,
                            AppSpacingTokens.medium,
                            AppSpacingTokens.xSmall,
                          ),

                          title: Row(
                            children: <Widget>[
                              Text(
                                category.items[index].emoji,
                                style: theme.textTheme.bodyLarge,
                              ),
                              const SizedBox(width: AppSpacingTokens.small),
                              Expanded(
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  alignment: AlignmentDirectional.centerStart,
                                  child: Text(
                                    category.items[index].id.title(
                                      localizations,
                                    ),
                                    maxLines: 1,
                                    softWrap: false,

                                    // همه زیرگروه‌ها دقیقاً یک سبک
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (index < category.items.length - 1)
                          Divider(
                            height: 1,
                            thickness: 1,
                            indent: AppSpacingTokens.medium,
                            endIndent: AppSpacingTokens.medium,
                            color: colors.outlineVariant.withValues(
                              alpha: 0.55,
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _applicantLabel(
  AppLocalizations localizations,
  PartnerApplicantType type,
) {
  final language = localizations.localeName.split('_').first.toLowerCase();

  if (language == 'fa') {
    return type == PartnerApplicantType.individual ? 'حقیقی' : 'حقوقی';
  }

  return type == PartnerApplicantType.individual
      ? localizations.partnerRegistrationIndividual
      : localizations.partnerRegistrationLegalEntity;
}

Color _categoryAccent(PartnerCategoryId id) {
  return switch (id) {
    PartnerCategoryId.stores => const Color(0xFF2E7D32),
    PartnerCategoryId.companies => const Color(0xFF3949AB),
    PartnerCategoryId.drivers => const Color(0xFFEF6C00),
    PartnerCategoryId.food => const Color(0xFFD84315),
    PartnerCategoryId.other => const Color(0xFF00897B),
  };
}
