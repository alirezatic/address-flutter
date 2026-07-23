import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:address/app/route_paths.dart';
import 'package:address/core/design_system/components/layout/app_page_scaffold.dart';
import 'package:address/core/design_system/tokens/app_design_tokens.dart';
import 'package:address/features/notifications/data/models/app_notification.dart';
import 'package:address/features/notifications/presentation/controller/notification_inbox_controller.dart';
import 'package:address/l10n/generated/app_localizations.dart';

// addressNotificationInboxV1
class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final NotificationInboxController _controller;
  bool _isMarkingAllRead = false;

  @override
  void initState() {
    super.initState();
    _controller = NotificationInboxController.instance
      ..addListener(_handleChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        unawaited(_controller.load(showLoading: true));
      }
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_handleChanged);
    super.dispose();
  }

  void _handleChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return AppPageScaffold(
      navigationIcon: Icons.arrow_back_ios_new_rounded,
      navigationLabel: localizations.notificationsBack,
      onNavigationPressed: () {
        if (context.canPop()) {
          context.pop();
          return;
        }

        context.go(AppRoutePaths.home);
      },
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppLayoutTokens.contentMaxWidth,
          ),
          child: RefreshIndicator(
            onRefresh: () => _controller.load(),
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              padding: const EdgeInsets.fromLTRB(
                AppLayoutTokens.screenHorizontalPadding,
                AppSpacingTokens.small,
                AppLayoutTokens.screenHorizontalPadding,
                AppSpacingTokens.xxLarge,
              ),
              children: <Widget>[
                _Header(
                  unreadCount: _controller.unreadCount,
                  isBusy: _isMarkingAllRead,
                  onMarkAllRead: _controller.unreadCount == 0
                      ? null
                      : _markAllRead,
                ),
                const SizedBox(height: AppSpacingTokens.small),
                Text(
                  localizations.notificationsSubtitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppSpacingTokens.large),
                if (_controller.isLoading && _controller.notifications.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(AppSpacingTokens.xxLarge),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (_controller.hasError &&
                    _controller.notifications.isEmpty)
                  _MessageCard(
                    icon: Icons.cloud_off_rounded,
                    title: localizations.notificationsLoadFailed,
                    body: localizations.notificationsLoadFailedDescription,
                    actionLabel: localizations.retry,
                    onAction: () => _controller.load(showLoading: true),
                  )
                else if (_controller.notifications.isEmpty)
                  _MessageCard(
                    icon: Icons.notifications_none_rounded,
                    title: localizations.notificationsEmpty,
                    body: localizations.notificationsEmptyDescription,
                  )
                else ...<Widget>[
                  if (_controller.hasError) ...<Widget>[
                    _InlineWarning(
                      message: localizations.notificationsRefreshFailed,
                    ),
                    const SizedBox(height: AppSpacingTokens.medium),
                  ],
                  for (
                    var index = 0;
                    index < _controller.notifications.length;
                    index++
                  ) ...<Widget>[
                    _NotificationCard(
                      notification: _controller.notifications[index],
                      onTap: () =>
                          _openNotification(_controller.notifications[index]),
                    ),
                    if (index != _controller.notifications.length - 1)
                      const SizedBox(height: AppSpacingTokens.medium),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _markAllRead() async {
    if (_isMarkingAllRead) {
      return;
    }

    setState(() {
      _isMarkingAllRead = true;
    });

    final succeeded = await _controller.markAllRead();

    if (!mounted) {
      return;
    }

    setState(() {
      _isMarkingAllRead = false;
    });

    if (!succeeded) {
      _showMessage(AppLocalizations.of(context).notificationsMarkAllFailed);
    }
  }

  Future<void> _openNotification(AppNotification notification) async {
    final succeeded = await _controller.markRead(notification.id);

    if (!mounted) {
      return;
    }

    if (!succeeded) {
      _showMessage(AppLocalizations.of(context).notificationsReadFailed);
    }

    final applicationId = notification.applicationId;

    if (applicationId == null) {
      return;
    }

    await context.push(
      AppRoutePaths.partnerApplicationDetailsLocation(applicationId),
    );

    if (mounted) {
      unawaited(_controller.load());
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.unreadCount,
    required this.isBusy,
    required this.onMarkAllRead,
  });

  final int unreadCount;
  final bool isBusy;
  final VoidCallback? onMarkAllRead;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Column(
      children: <Widget>[
        Text(
          localizations.notificationsTitle,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: AppSpacingTokens.medium),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Chip(
              avatar: const Icon(Icons.mark_email_unread_rounded, size: 18),
              label: Text(
                '${localizations.notificationsUnread}: '
                '$unreadCount',
              ),
            ),
            const SizedBox(width: AppSpacingTokens.small),
            TextButton.icon(
              onPressed: isBusy ? null : onMarkAllRead,
              icon: isBusy
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.done_all_rounded),
              label: Text(localizations.notificationsMarkAllRead),
            ),
          ],
        ),
      ],
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.notification, required this.onTap});

  final AppNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final localizations = AppLocalizations.of(context);
    final text = _NotificationText.resolve(notification, localizations);
    final trackingCode = notification.trackingCode;
    final localDate = notification.createdAt.toLocal();
    final materialLocalizations = MaterialLocalizations.of(context);
    final dateText = materialLocalizations.formatMediumDate(localDate);
    final timeText = materialLocalizations.formatTimeOfDay(
      TimeOfDay.fromDateTime(localDate),
    );

    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      color: notification.isUnread
          ? colors.primaryContainer.withValues(alpha: 0.42)
          : null,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacingTokens.large),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: notification.isUnread
                      ? colors.primary
                      : colors.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  text.icon,
                  color: notification.isUnread
                      ? colors.onPrimary
                      : colors.onSurfaceVariant,
                ),
              ),
              const SizedBox(width: AppSpacingTokens.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            text.title,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                        ),
                        if (notification.isUnread)
                          Container(
                            width: 10,
                            height: 10,
                            margin: const EdgeInsets.only(top: 6),
                            decoration: BoxDecoration(
                              color: colors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacingTokens.xSmall),
                    Text(text.body, style: const TextStyle(height: 1.55)),
                    if (trackingCode != null) ...<Widget>[
                      const SizedBox(height: AppSpacingTokens.small),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Text(
                          '${localizations.partnerApplicationTrackingCode}: '
                          '$trackingCode',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacingTokens.small),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.schedule_rounded,
                          size: 16,
                          color: colors.onSurfaceVariant,
                        ),
                        const SizedBox(width: AppSpacingTokens.xSmall),
                        Text(
                          '$dateText • $timeText',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colors.onSurfaceVariant),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: colors.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NotificationText {
  const _NotificationText({
    required this.title,
    required this.body,
    required this.icon,
  });

  final String title;
  final String body;
  final IconData icon;

  static _NotificationText resolve(
    AppNotification notification,
    AppLocalizations localizations,
  ) {
    return switch (notification.type) {
      AppNotificationType.partnerApplicationReviewStarted => _NotificationText(
        title: localizations.notificationPartnerReviewStartedTitle,
        body: localizations.notificationPartnerReviewStartedBody,
        icon: Icons.manage_search_rounded,
      ),
      AppNotificationType.partnerApplicationNeedsCorrection =>
        _NotificationText(
          title: localizations.notificationPartnerNeedsCorrectionTitle,
          body: localizations.notificationPartnerNeedsCorrectionBody,
          icon: Icons.rule_folder_rounded,
        ),
      AppNotificationType.partnerApplicationApproved => _NotificationText(
        title: localizations.notificationPartnerApprovedTitle,
        body: localizations.notificationPartnerApprovedBody,
        icon: Icons.verified_rounded,
      ),
      AppNotificationType.unknown => _NotificationText(
        title: localizations.notificationUnknownTitle,
        body: localizations.notificationUnknownBody,
        icon: Icons.notifications_rounded,
      ),
    };
  }
}

class _MessageCard extends StatelessWidget {
  const _MessageCard({
    required this.icon,
    required this.title,
    required this.body,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String body;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacingTokens.xLarge),
        child: Column(
          children: <Widget>[
            Icon(icon, size: 54, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: AppSpacingTokens.medium),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: AppSpacingTokens.small),
            Text(
              body,
              textAlign: TextAlign.center,
              style: const TextStyle(height: 1.5),
            ),
            if (actionLabel != null && onAction != null) ...<Widget>[
              const SizedBox(height: AppSpacingTokens.medium),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InlineWarning extends StatelessWidget {
  const _InlineWarning({required this.message});

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
        textAlign: TextAlign.center,
        style: TextStyle(
          color: colors.onErrorContainer,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
