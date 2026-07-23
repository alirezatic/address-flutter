import 'package:flutter/material.dart';

import 'package:address/features/distribution/domain/entities/distribution_order_summary.dart';
import 'package:address/features/distribution/presentation/utils/distribution_presenter.dart';
import 'package:address/features/distribution/presentation/widgets/distribution_status_badge.dart';
import 'package:address/l10n/generated/app_localizations.dart';

class DistributionOrderCard extends StatelessWidget {
  const DistributionOrderCard({
    required this.order,
    required this.onTap,
    super.key,
  });

  final DistributionOrderSummary order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      color: colors.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: 0.55)),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 620;

              final header = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.orderNumber,
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    order.name,
                    textDirection: TextDirection.ltr,
                    style: textTheme.titleMedium?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w800,
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
                    style: textTheme.labelMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    distributionNumberLabel(context, order.amountTotal),
                    style: textTheme.titleLarge?.copyWith(
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
                    header,
                    const SizedBox(height: 14),
                    amount,
                  ] else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: header),
                        const SizedBox(width: 20),
                        amount,
                      ],
                    ),
                  const SizedBox(height: 16),
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
                  const SizedBox(height: 16),
                  Divider(
                    height: 1,
                    color: colors.outlineVariant.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Icon(
                        Icons.event_outlined,
                        size: 19,
                        color: colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${localizations.plannedDelivery}: '
                          '${distributionDateLabel(context, order.plannedDeliveryDate)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium?.copyWith(
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.chevron_right_rounded, color: colors.primary),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
