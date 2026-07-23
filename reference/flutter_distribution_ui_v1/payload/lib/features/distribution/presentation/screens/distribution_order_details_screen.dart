import 'package:flutter/material.dart';

import 'package:address/features/distribution/domain/entities/distribution_order_details.dart';
import 'package:address/features/distribution/domain/entities/distribution_order_line.dart';
import 'package:address/features/distribution/domain/entities/distribution_reference.dart';
import 'package:address/features/distribution/domain/repositories/distribution_repository.dart';
import 'package:address/features/distribution/presentation/controllers/distribution_order_details_controller.dart';
import 'package:address/features/distribution/presentation/utils/distribution_presenter.dart';
import 'package:address/features/distribution/presentation/widgets/distribution_state_view.dart';
import 'package:address/features/distribution/presentation/widgets/distribution_status_badge.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class DistributionOrderDetailsScreen extends StatefulWidget {
  const DistributionOrderDetailsScreen({
    required this.orderName,
    this.repository,
    super.key,
  });

  final String orderName;
  final DistributionRepository? repository;

  @override
  State<DistributionOrderDetailsScreen> createState() =>
      _DistributionOrderDetailsScreenState();
}

class _DistributionOrderDetailsScreenState
    extends State<DistributionOrderDetailsScreen> {
  late final DistributionOrderDetailsController _controller;

  @override
  void initState() {
    super.initState();

    _controller = DistributionOrderDetailsController(
      repository: widget.repository,
    )..addListener(_handleControllerChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _controller.load(widget.orderName);
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

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        title: Text(localizations.distributionOrderDetails),
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return switch (_controller.state) {
      DistributionOrderDetailsState.idle ||
      DistributionOrderDetailsState.loading => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(localizations.distributionLoading),
            ],
          ),
        ),
      ),
      DistributionOrderDetailsState.error => ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          DistributionStateView(
            icon: Icons.receipt_long_outlined,
            title: localizations.distributionLoadError,
            message: distributionFailureMessage(
              localizations,
              _controller.failure,
            ),
            actionLabel: localizations.retry,
            onAction: () {
              _controller.load(widget.orderName);
            },
          ),
        ],
      ),
      DistributionOrderDetailsState.loaded => RefreshIndicator(
        onRefresh: () => _controller.load(widget.orderName),
        child: _DistributionOrderDetailsContent(
          order: _controller.order!,
        ),
      ),
    };
  }
}

class _DistributionOrderDetailsContent extends StatelessWidget {
  const _DistributionOrderDetailsContent({
    required this.order,
  });

  final DistributionOrderDetails order;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = constraints.maxWidth < 600 ? 16.0 : 28.0;

        return ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            16,
            horizontalPadding,
            36,
          ),
          children: [
            Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 980),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _OrderHeaderCard(order: order),
                    const SizedBox(height: 16),
                    _DetailsSection(
                      title: localizations.distributionOrderDetails,
                      children: [
                        _DetailItem(
                          icon: Icons.event_available_outlined,
                          label: localizations.plannedDelivery,
                          value: distributionDateLabel(
                            context,
                            order.plannedDeliveryDate,
                          ),
                        ),
                        _DetailItem(
                          icon: Icons.schedule_outlined,
                          label: localizations.createdDate,
                          value: distributionDateLabel(
                            context,
                            order.createdAt,
                            includeTime: true,
                          ),
                        ),
                        _DetailItem(
                          icon: Icons.account_balance_wallet_outlined,
                          label: localizations.walletReservedAmount,
                          value: distributionNumberLabel(
                            context,
                            order.walletReservedAmount,
                          ),
                        ),
                        _DetailItem(
                          icon: Icons.payments_outlined,
                          label: localizations.walletCapturedAmount,
                          value: distributionNumberLabel(
                            context,
                            order.walletCapturedAmount,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _DetailsSection(
                      title: localizations.deliveryStatus,
                      children: [
                        _DetailItem(
                          icon: Icons.person_outline_rounded,
                          label: localizations.deliveryDriver,
                          value: _referenceLabel(
                            localizations,
                            order.deliveryDriver,
                          ),
                        ),
                        _DetailItem(
                          icon: Icons.local_shipping_outlined,
                          label: localizations.deliveryTrip,
                          value: _referenceLabel(
                            localizations,
                            order.deliveryTrip,
                          ),
                        ),
                        _DetailItem(
                          icon: Icons.verified_outlined,
                          label: localizations.deliveryConfirmed,
                          value: distributionDateLabel(
                            context,
                            order.deliveryConfirmedAt,
                            includeTime: true,
                          ),
                        ),
                        _DetailItem(
                          icon: Icons.fact_check_outlined,
                          label: localizations.deliveryProof,
                          value:
                              order.deliveryProofReference ??
                              order.deliveryProofNote ??
                              localizations.notAvailable,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _OrderLinesSection(lines: order.lines),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  String _referenceLabel(
    AppLocalizations localizations,
    DistributionReference? reference,
  ) {
    return reference?.name ?? localizations.notAvailable;
  }
}

class _OrderHeaderCard extends StatelessWidget {
  const _OrderHeaderCard({
    required this.order,
  });

  final DistributionOrderDetails order;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            colors.primaryContainer.withValues(alpha: 0.86),
            colors.surfaceContainerLow,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.48),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 620;

          final identity = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.orderNumber,
                style: textTheme.labelLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                order.name,
                textDirection: TextDirection.ltr,
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          );

          final amount = Column(
            crossAxisAlignment: isCompact
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Text(
                localizations.totalAmount,
                style: textTheme.labelLarge?.copyWith(
                  color: colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                distributionNumberLabel(context, order.amountTotal),
                style: textTheme.headlineMedium?.copyWith(
                  color: colors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (isCompact) ...[
                identity,
                const SizedBox(height: 18),
                amount,
              ] else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: identity),
                    const SizedBox(width: 24),
                    amount,
                  ],
                ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  DistributionStatusBadge(
                    label: distributionOrderStateLabel(
                      localizations,
                      order.state,
                    ),
                    tone: distributionOrderBadgeTone(order.state),
                  ),
                  DistributionStatusBadge(
                    label: distributionWalletStateLabel(
                      localizations,
                      order.walletState,
                    ),
                    tone: distributionWalletBadgeTone(order.walletState),
                  ),
                  DistributionStatusBadge(
                    label: distributionDeliveryStateLabel(
                      localizations,
                      order.deliveryState,
                    ),
                    tone: distributionDeliveryBadgeTone(
                      order.deliveryState,
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 720 ? 2 : 1;
              final width = columns == 2
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  for (final child in children)
                    SizedBox(width: width, child: child),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DetailItem extends StatelessWidget {
  const _DetailItem({
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
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 21, color: colors.primary),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: textTheme.labelMedium?.copyWith(
                    color: colors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                SelectableText(
                  value,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderLinesSection extends StatelessWidget {
  const _OrderLinesSection({
    required this.lines,
  });

  final List<DistributionOrderLine> lines;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            localizations.orderProducts,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          if (lines.isEmpty)
            Text(
              localizations.notAvailable,
              style: textTheme.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            )
          else
            for (var index = 0; index < lines.length; index++) ...[
              _OrderLineCard(line: lines[index]),
              if (index != lines.length - 1) const SizedBox(height: 10),
            ],
        ],
      ),
    );
  }
}

class _OrderLineCard extends StatelessWidget {
  const _OrderLineCard({
    required this.line,
  });

  final DistributionOrderLine line;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            line.product?.name ?? localizations.notAvailable,
            style: textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 18,
            runSpacing: 10,
            children: [
              _LineValue(
                label: localizations.quantity,
                value: distributionNumberLabel(
                  context,
                  line.orderedQuantity,
                ),
              ),
              _LineValue(
                label: localizations.unitPrice,
                value: distributionNumberLabel(
                  context,
                  line.unitPrice,
                ),
              ),
              _LineValue(
                label: localizations.finalUnitPrice,
                value: distributionNumberLabel(
                  context,
                  line.finalUnitPrice,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineValue extends StatelessWidget {
  const _LineValue({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: textTheme.labelSmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
