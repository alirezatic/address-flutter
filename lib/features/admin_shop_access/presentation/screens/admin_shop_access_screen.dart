import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_entry.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_failure.dart';
import 'package:address/features/admin_shop_access/domain/entities/admin_shop_access_mutation.dart';
import 'package:address/features/admin_shop_access/domain/repositories/admin_shop_access_repository.dart';
import 'package:address/features/admin_shop_access/presentation/controllers/admin_shop_access_controller.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class AdminShopAccessScreen extends StatefulWidget {
  const AdminShopAccessScreen({this.repository, super.key});

  final AdminShopAccessRepository? repository;

  @override
  State<AdminShopAccessScreen> createState() => _AdminShopAccessScreenState();
}

class _AdminShopAccessScreenState extends State<AdminShopAccessScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _shopController = TextEditingController(
    text: '7',
  );
  final TextEditingController _filterShopController = TextEditingController();

  late final AdminShopAccessController _controller;

  bool _includeInactive = false;

  @override
  void initState() {
    super.initState();

    _controller = AdminShopAccessController(repository: widget.repository)
      ..addListener(_handleControllerChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.load();
      }
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_handleControllerChanged)
      ..dispose();
    _phoneController.dispose();
    _shopController.dispose();
    _filterShopController.dispose();
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _grant() {
    return _submit(grant: true);
  }

  Future<void> _revoke() {
    return _submit(grant: false);
  }

  Future<void> _submit({required bool grant}) async {
    final localizations = AppLocalizations.of(context);

    if (_formKey.currentState?.validate() != true) {
      return;
    }

    final shopId = int.parse(_shopController.text.trim());
    final phone = _phoneController.text.trim();

    final result = grant
        ? await _controller.grant(phone: phone, shopId: shopId)
        : await _controller.revoke(phone: phone, shopId: shopId);

    if (!mounted) {
      return;
    }

    if (result == null) {
      _showFailure(_controller.mutationFailure);
      return;
    }

    _phoneController.clear();

    final actionLabel = result.status == AdminShopAccessMutationStatus.granted
        ? localizations.adminAccessGranted
        : localizations.adminAccessRevoked;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            '$actionLabel · '
            '${result.phoneMasked} · '
            '${localizations.shopId} '
            '${result.shopId}',
          ),
        ),
      );
  }

  Future<void> _applyFilters() async {
    final text = _filterShopController.text.trim();
    final shopId = text.isEmpty ? null : int.tryParse(text);

    if (text.isNotEmpty && (shopId == null || shopId <= 0)) {
      final localizations = AppLocalizations.of(context);

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(localizations.invalidShopId)));
      return;
    }

    await _controller.applyFilters(
      shopId: shopId,
      includeInactive: _includeInactive,
    );
  }

  void _showFailure(AdminShopAccessFailure? failure) {
    final localizations = AppLocalizations.of(context);
    final message = _failureMessage(localizations, failure);

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(localizations.adminShopAccess),
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: _controller.load,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final horizontalPadding = constraints.maxWidth < 600
                  ? 16.0
                  : 28.0;

              return ListView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  32,
                ),
                children: [
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 980),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _AccessFormCard(
                            formKey: _formKey,
                            phoneController: _phoneController,
                            shopController: _shopController,
                            isBusy: _controller.isMutating,
                            onGrant: _grant,
                            onRevoke: _revoke,
                          ),
                          const SizedBox(height: 16),
                          _AccessFilterCard(
                            shopController: _filterShopController,
                            includeInactive: _includeInactive,
                            isBusy:
                                _controller.isLoading || _controller.isMutating,
                            onIncludeInactiveChanged: (value) {
                              setState(() {
                                _includeInactive = value;
                              });
                            },
                            onApply: _applyFilters,
                          ),
                          const SizedBox(height: 16),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: _buildContent(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return switch (_controller.state) {
      AdminShopAccessState.idle || AdminShopAccessState.loading => Padding(
        key: const ValueKey('admin-shop-access-loading'),
        padding: const EdgeInsets.symmetric(vertical: 52),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(localizations.adminAccessLoading),
          ],
        ),
      ),
      AdminShopAccessState.empty => _AdminStateCard(
        key: const ValueKey('admin-shop-access-empty'),
        icon: Icons.admin_panel_settings_outlined,
        title: localizations.noAdminShopAccess,
        message: localizations.noAdminShopAccessDescription,
      ),
      AdminShopAccessState.forbidden => _AdminStateCard(
        key: const ValueKey('admin-shop-access-forbidden'),
        icon: Icons.lock_outline_rounded,
        title: localizations.adminAccessForbiddenTitle,
        message: localizations.adminAccessForbiddenMessage,
      ),
      AdminShopAccessState.error => _AdminStateCard(
        key: const ValueKey('admin-shop-access-error'),
        icon: Icons.cloud_off_rounded,
        title: localizations.adminAccessLoadError,
        message: _failureMessage(localizations, _controller.failure),
        actionLabel: localizations.retry,
        onAction: _controller.load,
      ),
      AdminShopAccessState.loaded => Column(
        key: const ValueKey('admin-shop-access-loaded'),
        children: [
          for (var index = 0; index < _controller.access.length; index++) ...[
            _AccessEntryCard(entry: _controller.access[index]),
            if (index != _controller.access.length - 1)
              const SizedBox(height: 10),
          ],
        ],
      ),
    };
  }

  String _failureMessage(
    AppLocalizations localizations,
    AdminShopAccessFailure? failure,
  ) {
    if (failure == null) {
      return localizations.adminAccessLoadError;
    }

    return switch (failure.kind) {
      AdminShopAccessFailureKind.unauthorized =>
        localizations.adminAccessUnauthorized,
      AdminShopAccessFailureKind.forbidden =>
        localizations.adminAccessForbiddenMessage,
      AdminShopAccessFailureKind.validation =>
        localizations.adminAccessValidationError,
      AdminShopAccessFailureKind.network =>
        localizations.adminAccessNetworkError,
      AdminShopAccessFailureKind.server => localizations.adminAccessServerError,
      AdminShopAccessFailureKind.invalidResponse =>
        localizations.adminAccessInvalidResponse,
    };
  }
}

class _AccessFormCard extends StatelessWidget {
  const _AccessFormCard({
    required this.formKey,
    required this.phoneController,
    required this.shopController,
    required this.isBusy,
    required this.onGrant,
    required this.onRevoke,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController phoneController;
  final TextEditingController shopController;
  final bool isBusy;
  final Future<void> Function() onGrant;
  final Future<void> Function() onRevoke;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(Icons.person_add_alt_1_rounded, color: colors.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      localizations.manageShopAccess,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                localizations.adminShopAccessPrivacyNote,
                style: textTheme.bodyMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: phoneController,
                enabled: !isBusy,
                keyboardType: TextInputType.phone,
                textDirection: TextDirection.ltr,
                autofillHints: const [AutofillHints.telephoneNumber],
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'[0-9\u06F0-\u06F9\u0660-\u0669+\-()\s]'),
                  ),
                ],
                decoration: InputDecoration(
                  labelText: localizations.mobileNumber,
                  hintText: '09121234567',
                  prefixIcon: const Icon(Icons.phone_android_rounded),
                ),
                validator: (value) {
                  if (!_isValidIranianMobile(value)) {
                    return localizations.invalidAdminMobile;
                  }

                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: shopController,
                enabled: !isBusy,
                keyboardType: TextInputType.number,
                textDirection: TextDirection.ltr,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: localizations.shopId,
                  prefixIcon: const Icon(Icons.storefront_outlined),
                ),
                validator: (value) {
                  final shopId = int.tryParse(value?.trim() ?? '');

                  if (shopId == null || shopId <= 0) {
                    return localizations.invalidShopId;
                  }

                  return null;
                },
              ),
              const SizedBox(height: 8),
              Text(
                localizations.shopIdVerificationNote,
                style: textTheme.bodySmall?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                alignment: WrapAlignment.end,
                children: [
                  OutlinedButton.icon(
                    onPressed: isBusy ? null : onRevoke,
                    icon: const Icon(Icons.person_remove_outlined),
                    label: Text(localizations.revokeAccess),
                  ),
                  FilledButton.icon(
                    onPressed: isBusy ? null : onGrant,
                    icon: isBusy
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.verified_user_outlined),
                    label: Text(localizations.grantAccess),
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

class _AccessFilterCard extends StatelessWidget {
  const _AccessFilterCard({
    required this.shopController,
    required this.includeInactive,
    required this.isBusy,
    required this.onIncludeInactiveChanged,
    required this.onApply,
  });

  final TextEditingController shopController;
  final bool includeInactive;
  final bool isBusy;
  final ValueChanged<bool> onIncludeInactiveChanged;
  final Future<void> Function() onApply;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              localizations.accessListFilters,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: shopController,
                    enabled: !isBusy,
                    keyboardType: TextInputType.number,
                    textDirection: TextDirection.ltr,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: localizations.optionalShopId,
                      prefixIcon: const Icon(Icons.filter_alt_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                FilledButton.tonal(
                  onPressed: isBusy ? null : onApply,
                  child: Text(localizations.applyFilters),
                ),
              ],
            ),
            SwitchListTile.adaptive(
              contentPadding: EdgeInsets.zero,
              title: Text(localizations.includeInactiveAccess),
              value: includeInactive,
              onChanged: isBusy ? null : onIncludeInactiveChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class _AccessEntryCard extends StatelessWidget {
  const _AccessEntryCard({required this.entry});

  final AdminShopAccessEntry entry;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final statusLabel = entry.active
        ? localizations.activeAccess
        : localizations.inactiveAccess;

    final statusColor = entry.active ? colors.primary : colors.error;

    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.12),
          foregroundColor: statusColor,
          child: Icon(
            entry.active
                ? Icons.verified_user_outlined
                : Icons.lock_outline_rounded,
          ),
        ),
        title: Text(
          entry.phoneMasked,
          textDirection: TextDirection.ltr,
          style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
        ),
        subtitle: Text(
          '${localizations.shopId}: '
          '${entry.shopId}',
        ),
        trailing: DecoratedBox(
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Text(
              statusLabel,
              style: textTheme.labelMedium?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminStateCard extends StatelessWidget {
  const _AdminStateCard({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final Future<void> Function()? onAction;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 38),
        child: Column(
          children: [
            Icon(icon, size: 48, color: colors.onSurfaceVariant),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

bool _isValidIranianMobile(String? value) {
  if (value == null || value.trim().isEmpty) {
    return false;
  }

  final translated = value
      .trim()
      .replaceAllMapped(
        RegExp(r'[\u06F0-\u06F9]'),
        (match) => (match.group(0)!.codeUnitAt(0) - 0x06F0).toString(),
      )
      .replaceAllMapped(
        RegExp(r'[\u0660-\u0669]'),
        (match) => (match.group(0)!.codeUnitAt(0) - 0x0660).toString(),
      );

  final digits = translated.replaceAll(RegExp(r'\D'), '');

  return RegExp(r'^(?:0098|98|0)?9\d{9}$').hasMatch(digits);
}
