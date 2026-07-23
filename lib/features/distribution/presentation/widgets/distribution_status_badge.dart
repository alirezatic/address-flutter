import 'package:flutter/material.dart';

enum DistributionBadgeTone { neutral, primary, success, warning, error }

class DistributionStatusBadge extends StatelessWidget {
  const DistributionStatusBadge({
    required this.label,
    this.tone = DistributionBadgeTone.neutral,
    super.key,
  });

  final String label;
  final DistributionBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final (foreground, background) = switch (tone) {
      DistributionBadgeTone.primary => (
        colors.primary,
        colors.primaryContainer.withValues(alpha: 0.72),
      ),
      DistributionBadgeTone.success => (
        const Color(0xFF1B5E20),
        const Color(0xFFE8F5E9),
      ),
      DistributionBadgeTone.warning => (
        const Color(0xFF8A4B00),
        const Color(0xFFFFF3E0),
      ),
      DistributionBadgeTone.error => (
        colors.error,
        colors.errorContainer.withValues(alpha: 0.72),
      ),
      DistributionBadgeTone.neutral => (
        colors.onSurfaceVariant,
        colors.surfaceContainerHighest,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

DistributionBadgeTone distributionOrderBadgeTone(String value) {
  return switch (value.toLowerCase()) {
    'received' => DistributionBadgeTone.success,
    'confirmed' => DistributionBadgeTone.primary,
    'draft' => DistributionBadgeTone.warning,
    'cancelled' || 'canceled' => DistributionBadgeTone.error,
    _ => DistributionBadgeTone.neutral,
  };
}

DistributionBadgeTone distributionWalletBadgeTone(String value) {
  return switch (value.toLowerCase()) {
    'paid' => DistributionBadgeTone.success,
    'reserved' => DistributionBadgeTone.warning,
    'unpaid' => DistributionBadgeTone.error,
    'refunded' => DistributionBadgeTone.primary,
    _ => DistributionBadgeTone.neutral,
  };
}

DistributionBadgeTone distributionDeliveryBadgeTone(String value) {
  return switch (value.toLowerCase()) {
    'delivered' => DistributionBadgeTone.success,
    'in_transit' || 'in-transit' || 'assigned' => DistributionBadgeTone.primary,
    'pending' => DistributionBadgeTone.warning,
    _ => DistributionBadgeTone.neutral,
  };
}
