import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/features/distribution/domain/entities/distribution_failure.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_summary.dart';
import 'package:address/features/distribution/domain/repositories/distribution_repository.dart';
import 'package:address/features/distribution/presentation/controllers/distribution_orders_controller.dart';
import 'package:address/features/distribution/presentation/widgets/distribution_order_card.dart';
import 'package:address/features/distribution/presentation/widgets/distribution_state_view.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class DistributionOrdersScreen extends StatefulWidget {
  const DistributionOrdersScreen({this.repository, super.key});

  final DistributionRepository? repository;

  @override
  State<DistributionOrdersScreen> createState() =>
      _DistributionOrdersScreenState();
}

class _DistributionOrdersScreenState extends State<DistributionOrdersScreen> {
  late final DistributionOrdersController _controller;

  @override
  void initState() {
    super.initState();

    _controller = DistributionOrdersController(repository: widget.repository)
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
    super.dispose();
  }

  void _handleControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _openOrder(DistributionOrderSummary order) async {
    final location = Uri(
      path: AppRoutePaths.distributionOrderDetails,
      queryParameters: <String, String>{'name': order.name},
    ).toString();

    await context.push(location);
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(localizations.distributionOrders),
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 600 ? 16.0 : 28.0;

            return RefreshIndicator(
              onRefresh: _controller.load,
              child: ListView(
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
                          _DistributionFilterBar(controller: _controller),
                          const SizedBox(height: 18),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 220),
                            child: _buildContent(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return switch (_controller.state) {
      DistributionOrdersState.idle ||
      DistributionOrdersState.loading => Padding(
        key: const ValueKey('distribution-loading'),
        padding: const EdgeInsets.symmetric(vertical: 52),
        child: Column(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(localizations.distributionLoading),
          ],
        ),
      ),
      DistributionOrdersState.empty => DistributionStateView(
        key: const ValueKey('distribution-empty'),
        icon: Icons.inventory_2_outlined,
        title: localizations.noDistributionOrders,
        message: localizations.noDistributionOrdersDescription,
      ),
      DistributionOrdersState.error => DistributionStateView(
        key: const ValueKey('distribution-error'),
        icon: Icons.cloud_off_rounded,
        title: localizations.distributionLoadError,
        message: _failureMessage(localizations),
        actionLabel: localizations.retry,
        onAction: _controller.load,
      ),
      DistributionOrdersState.loaded => Column(
        key: const ValueKey('distribution-loaded'),
        children: [
          for (var index = 0; index < _controller.orders.length; index++) ...[
            DistributionOrderCard(
              order: _controller.orders[index],
              onTap: () {
                _openOrder(_controller.orders[index]);
              },
            ),
            if (index != _controller.orders.length - 1)
              const SizedBox(height: 12),
          ],
        ],
      ),
    };
  }

  String _failureMessage(AppLocalizations localizations) {
    final failure = _controller.failure;

    if (failure == null) {
      return localizations.distributionLoadError;
    }

    return switch (failure.kind) {
      DistributionFailureKind.unauthorized =>
        localizations.distributionUnauthorized,
      DistributionFailureKind.forbidden => localizations.distributionForbidden,
      DistributionFailureKind.network => localizations.distributionNetworkError,
      DistributionFailureKind.notFound =>
        localizations.distributionOrderNotFound,
      DistributionFailureKind.server => localizations.distributionServerError,
      DistributionFailureKind.invalidResponse =>
        localizations.distributionInvalidResponse,
    };
  }
}

class _DistributionFilterBar extends StatelessWidget {
  const _DistributionFilterBar({required this.controller});

  final DistributionOrdersController controller;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final options = <({String label, String? value})>[
      (label: localizations.allOrders, value: null),
      (label: localizations.confirmedOrders, value: 'confirmed'),
      (label: localizations.receivedOrders, value: 'received'),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.filter_alt_outlined,
                  size: 20,
                  color: colors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    localizations.filterByState,
                    style: textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                if (controller.selectedState != null)
                  TextButton(
                    onPressed: controller.isLoading
                        ? null
                        : controller.clearFilters,
                    child: Text(localizations.clearFilters),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final option in options)
                  ChoiceChip(
                    label: Text(option.label),
                    selected: controller.selectedState == option.value,
                    onSelected: controller.isLoading
                        ? null
                        : (_) {
                            controller.setStateFilter(option.value);
                          },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
