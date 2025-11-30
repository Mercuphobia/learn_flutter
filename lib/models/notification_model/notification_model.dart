import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'notification_model.freezed.dart';
part 'notification_model.g.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required String title,
    required String subtitle,
    required DateTime date,
    String? description,
    @Default('chart') String type,
    @Default(false) bool isRead,
  }) = _NotificationModel;

  factory NotificationModel.fromJson(Map<String, Object?> json)
    => _$NotificationModelFromJson(json);
}



// DANH SÁCH DỮ LIỆU MẪU (15 ITEM)
final List<NotificationModel> mockNotifications = [
  // 1. Chart - Chưa đọc - Mới nhất
  NotificationModel(
    title: "Weekly Statistic Available",
    subtitle: "Hello Phillip, your report for week 42 is ready.",
    description: "Your productivity has increased by 20% compared to last week. Check the detailed charts to see breakdown by tasks and projects.",
    type: "chart",
    isRead: false,
    date: DateTime(2025, 11, 29, 9, 30),
  ),

  // 2. Warning - Chưa đọc - Quan trọng
  NotificationModel(
    title: "Deadline Warning: UI Design",
    subtitle: "Task 'Homepage Redesign' is due in 2 hours.",
    description: "Please submit your Figma files before 11:30 AM. The client meeting is scheduled for this afternoon.",
    type: "warning",
    isRead: false,
    date: DateTime(2025, 11, 29, 8, 00),
  ),

  // 3. Check - Đã đọc
  NotificationModel(
    title: "Task Completed: Backend API",
    subtitle: "You successfully merged PR #1024.",
    description: "The authentication module has been deployed to the staging server. QA team will start testing shortly.",
    type: "check",
    isRead: true,
    date: DateTime(2025, 11, 28, 16, 45),
  ),

  // 4. Warning - Đã đọc
  NotificationModel(
    title: "Server Maintenance",
    subtitle: "Scheduled maintenance in 24 hours.",
    description: "The server will be down for upgrades from 00:00 to 02:00. Please save your work.",
    type: "warning",
    isRead: true,
    date: DateTime(2025, 11, 28, 10, 00),
  ),

  // 5. Chart - Đã đọc
  NotificationModel(
    title: "Project Progress: 80%",
    subtitle: "The 'E-commerce App' is ahead of schedule.",
    description: "Great job team! We are 5 days ahead of the initial timeline. Keep up the good work.",
    type: "chart",
    isRead: true,
    date: DateTime(2025, 11, 27, 14, 20),
  ),

  // 6. Check - Đã đọc
  NotificationModel(
    title: "Payment Received",
    subtitle: "Salary for November has been transferred.",
    description: "Your salary has been credited to your bank account ending in **88. Please check your banking app.",
    type: "check",
    isRead: true,
    date: DateTime(2025, 11, 27, 9, 00),
  ),

  // 7. Warning - Chưa đọc
  NotificationModel(
    title: "Meeting Reminder",
    subtitle: "Daily Standup starting in 15 minutes.",
    description: "Join the Zoom link: https://zoom.us/j/123456789. Prepare your updates regarding the login bug.",
    type: "warning",
    isRead: false,
    date: DateTime(2025, 11, 26, 9, 45),
  ),

  // 8. Check - Đã đọc
  NotificationModel(
    title: "New Comment on Jira",
    subtitle: "Alex tagged you in ticket DEV-123.",
    description: "Alex wrote: 'Can you please check the logic for the user permission here? It seems to be failing for Admin role.'",
    type: "check",
    isRead: true,
    date: DateTime(2025, 11, 25, 15, 30),
  ),

  // 9. Chart - Đã đọc
  NotificationModel(
    title: "Storage Usage Alert",
    subtitle: "You have used 90% of your cloud storage.",
    description: "Please archive old project files or upgrade your plan to avoid interruption.",
    type: "chart",
    isRead: true,
    date: DateTime(2025, 11, 24, 11, 00),
  ),

  // 10. Warning - Đã đọc
  NotificationModel(
    title: "Password Expiring",
    subtitle: "Your password will expire in 3 days.",
    description: "Security policy requires a password change every 90 days. Click here to update now.",
    type: "warning",
    isRead: true,
    date: DateTime(2025, 11, 23, 08, 00),
  ),

  // 11. Check - Đã đọc
  NotificationModel(
    title: "Code Review Passed",
    subtitle: "Your code for 'Dark Mode' is approved.",
    description: "2 reviewers approved your changes. You can now merge the branch to main.",
    type: "check",
    isRead: true,
    date: DateTime(2025, 11, 22, 17, 15),
  ),

  // 12. Warning - Đã đọc
  NotificationModel(
    title: "Missed Call",
    subtitle: "You missed a call from HR Department.",
    description: "Please call back at extension 505 when you are available.",
    type: "warning",
    isRead: true,
    date: DateTime(2025, 11, 21, 10, 30),
  ),

  // 13. Chart - Đã đọc
  NotificationModel(
    title: "Performance Review",
    subtitle: "Q3 Performance results are out.",
    description: "You achieved a score of 4.5/5. Comments: 'Excellent problem solving skills'.",
    type: "chart",
    isRead: true,
    date: DateTime(2025, 11, 20, 13, 00),
  ),

  // 14. Check - Đã đọc
  NotificationModel(
    title: "System Update",
    subtitle: "Flutter SDK updated to version 3.29.",
    description: "New features include improved Impeller rendering and Dart 3.5 support.",
    type: "check",
    isRead: true,
    date: DateTime(2025, 11, 19, 09, 00),
  ),

  // 15. Warning - Đã đọc
  NotificationModel(
    title: "Office Closed",
    subtitle: "Office will be closed on Friday.",
    description: "Due to the company retreat, the office will be closed. Please work remotely if necessary.",
    type: "warning",
    isRead: true,
    date: DateTime(2025, 11, 18, 16, 00),
  ),
];