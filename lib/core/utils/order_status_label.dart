import 'package:flutter/widgets.dart';

import '../../l10n/generated/app_localizations.dart';

/// Maps a `delivery_orders.status` value (or `orders.status`) to its
/// localized label. Falls back to the raw value if the status is unknown.
String localizedOrderStatus(BuildContext context, String status) {
  final l = AppLocalizations.of(context);
  return switch (status) {
    'pending' => l.statusPending,
    'confirmed' => l.statusConfirmed,
    'preparing' => l.statusPreparing,
    'ready_for_delivery' => l.statusReadyForDelivery,
    'out_for_delivery' => l.statusOutForDelivery,
    'delivered' => l.statusDelivered,
    'cancelled' => l.statusCancelled,
    'refunded' => l.statusRefunded,
    _ => status,
  };
}
