import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:address/features/distribution/domain/entities/distribution_failure.dart';
import 'package:address/l10n/generated/app_localizations.dart';

String distributionOrderStateLabel(
  AppLocalizations localizations,
  String value,
) {
  return switch (value.toLowerCase()) {
    'draft' => localizations.stateDraft,
    'confirmed' => localizations.stateConfirmed,
    'received' => localizations.stateReceived,
    'cancelled' || 'canceled' => localizations.stateCancelled,
    _ => value,
  };
}

String distributionWalletStateLabel(
  AppLocalizations localizations,
  String value,
) {
  return switch (value.toLowerCase()) {
    'paid' => localizations.walletPaid,
    'reserved' => localizations.walletReserved,
    'unpaid' => localizations.walletUnpaid,
    'refunded' => localizations.walletRefunded,
    _ => value,
  };
}

String distributionDeliveryStateLabel(
  AppLocalizations localizations,
  String value,
) {
  return switch (value.toLowerCase()) {
    'delivered' => localizations.deliveryDelivered,
    'none' => localizations.deliveryNone,
    'pending' => localizations.deliveryPending,
    'assigned' => localizations.deliveryAssigned,
    'in_transit' || 'in-transit' => localizations.deliveryInTransit,
    _ => value,
  };
}

String distributionFailureMessage(
  AppLocalizations localizations,
  DistributionFailure? failure,
) {
  return switch (failure?.kind) {
    DistributionFailureKind.network => localizations.distributionNetworkError,
    DistributionFailureKind.notFound =>
      localizations.distributionOrderNotFound,
    DistributionFailureKind.server => localizations.distributionServerError,
    DistributionFailureKind.invalidResponse =>
      localizations.distributionInvalidResponse,
    null => localizations.distributionLoadError,
  };
}

String distributionDateLabel(
  BuildContext context,
  DateTime? value, {
  bool includeTime = false,
}) {
  final localizations = AppLocalizations.of(context);

  if (value == null) {
    return localizations.notAvailable;
  }

  final material = MaterialLocalizations.of(context);
  final date = material.formatMediumDate(value);

  if (!includeTime) {
    return date;
  }

  final time = material.formatTimeOfDay(
    TimeOfDay.fromDateTime(value),
    alwaysUse24HourFormat: MediaQuery.alwaysUse24HourFormatOf(context),
  );

  return '$date · $time';
}

String distributionNumberLabel(BuildContext context, double value) {
  final locale = Localizations.localeOf(context).toLanguageTag();
  final formatter = NumberFormat.decimalPattern(locale);

  if (value == value.roundToDouble()) {
    return formatter.format(value.toInt());
  }

  formatter.minimumFractionDigits = 0;
  formatter.maximumFractionDigits = 2;
  return formatter.format(value);
}
