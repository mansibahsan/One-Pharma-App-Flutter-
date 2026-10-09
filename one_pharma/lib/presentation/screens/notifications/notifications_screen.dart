import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:one_pharma/core/theme/app_colors.dart';
import 'package:one_pharma/core/theme/app_text_styles.dart';
import 'package:one_pharma/data/models/notification_model.dart';
import 'package:one_pharma/providers/notification_provider.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationProvider);
    final notifNotifier = ref.read(notificationProvider.notifier);

    final todayList =
        notifications.where((n) => n.group == NotificationGroup.today).toList();
    final yesterdayList =
        notifications.where((n) => n.group == NotificationGroup.yesterday).toList();
    final lastWeekList =
        notifications.where((n) => n.group == NotificationGroup.lastWeek).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notification',
          style: AppTextStyles.h3.copyWith(fontSize: 18),
        ),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () => notifNotifier.clearAll(),
              child: Text(
                'Clear all',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_none_rounded,
                      size: 64,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(height: 16),
                    Text('No notifications', style: AppTextStyles.h3),
                    const SizedBox(height: 6),
                    Text(
                      'Promotions and order updates will show up here',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
              )
            : ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  if (todayList.isNotEmpty) ...[
                    _buildSectionHeader('Today', () {
                      notifNotifier.clearGroup(NotificationGroup.today);
                    }),
                    ...todayList.map((n) => _buildNotifCard(context, ref, n)),
                    const SizedBox(height: 16),
                  ],
                  if (yesterdayList.isNotEmpty) ...[
                    _buildSectionHeader('Yesterday', () {
                      notifNotifier.clearGroup(NotificationGroup.yesterday);
                    }),
                    ...yesterdayList.map((n) => _buildNotifCard(context, ref, n)),
                    const SizedBox(height: 16),
                  ],
                  if (lastWeekList.isNotEmpty) ...[
                    _buildSectionHeader('Last week', () {
                      notifNotifier.clearGroup(NotificationGroup.lastWeek);
                    }),
                    ...lastWeekList.map((n) => _buildNotifCard(context, ref, n)),
                  ],
                ],
              ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onClear) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(fontSize: 14),
          ),
          InkWell(
            onTap: onClear,
            child: Text(
              'Clear',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotifCard(
      BuildContext context, WidgetRef ref, NotificationModel notif) {
    return GestureDetector(
      onTap: () {
        ref.read(notificationProvider.notifier).markAsRead(notif.id);
        context.push('/category/All');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notif.isRead ? Colors.white : AppColors.primaryLight.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderSubtle),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_active_outlined,
                color: AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notif.title,
                          style: AppTextStyles.h3.copyWith(fontSize: 14),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        notif.time,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notif.message,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
