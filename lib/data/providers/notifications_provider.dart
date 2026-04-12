import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:audioplayers/audioplayers.dart';
import 'settings_provider.dart';

/// Notification item
class AppNotification {
  final String id;
  final String title;
  final String message;
  final DateTime timestamp;
  final String type; // 'order', 'system', 'info'
  final bool isRead;
  final String? orderId;

  const AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
    this.orderId,
  });

  AppNotification copyWith({bool? isRead}) {
    return AppNotification(
      id: id,
      title: title,
      message: message,
      timestamp: timestamp,
      type: type,
      isRead: isRead ?? this.isRead,
      orderId: orderId,
    );
  }
}

/// Notifications state
class NotificationsState {
  final List<AppNotification> notifications;
  final int unreadCount;

  const NotificationsState({
    this.notifications = const [],
    this.unreadCount = 0,
  });

  NotificationsState copyWith({
    List<AppNotification>? notifications,
    int? unreadCount,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

/// Notifications notifier
class NotificationsNotifier extends StateNotifier<NotificationsState> {
  final Ref _ref;
  final AudioPlayer _audioPlayer = AudioPlayer();

  NotificationsNotifier(this._ref) : super(const NotificationsState());

  Future<void> addNotification({
    required String title,
    required String message,
    required String type,
    String? orderId,
  }) async {
    final notification = AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      timestamp: DateTime.now(),
      type: type,
      orderId: orderId,
    );

    state = state.copyWith(
      notifications: [notification, ...state.notifications],
      unreadCount: state.unreadCount + 1,
    );

    // Play sound if enabled
    final settings = _ref.read(settingsProvider);
    if (settings.soundAlerts && settings.orderNotifications) {
      await _playNotificationSound(settings.notificationSoundIndex);
    }
  }

  Future<void> _playNotificationSound(int soundIndex) async {
    try {
      // Use different notification sounds based on index
      final sounds = [
        'notification_1.wav',
        'notification_2.wav',
        'notification_3.wav',
      ];
      final soundFile = sounds[soundIndex % sounds.length];
      await _audioPlayer.play(AssetSource('sounds/$soundFile'));
    } catch (e) {
      // Sound file might not exist, ignore error
    }
  }

  void markAsRead(String id) {
    final index = state.notifications.indexWhere((n) => n.id == id);
    if (index != -1 && !state.notifications[index].isRead) {
      final updated = List<AppNotification>.from(state.notifications);
      updated[index] = updated[index].copyWith(isRead: true);
      state = state.copyWith(
        notifications: updated,
        unreadCount: (state.unreadCount - 1).clamp(0, state.notifications.length),
      );
    }
  }

  void markAllAsRead() {
    final updated = state.notifications.map((n) => n.copyWith(isRead: true)).toList();
    state = state.copyWith(
      notifications: updated,
      unreadCount: 0,
    );
  }

  void clearAll() {
    state = const NotificationsState();
  }

  void removeNotification(String id) {
    final notification = state.notifications.firstWhere(
      (n) => n.id == id,
      orElse: () => throw Exception('Notification not found'),
    );
    final updated = state.notifications.where((n) => n.id != id).toList();
    state = state.copyWith(
      notifications: updated,
      unreadCount: notification.isRead ? state.unreadCount : state.unreadCount - 1,
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

/// Notifications provider
final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, NotificationsState>((ref) {
  return NotificationsNotifier(ref);
});

/// Unread count provider
final unreadNotificationsCountProvider = Provider<int>((ref) {
  return ref.watch(notificationsProvider).unreadCount;
});
