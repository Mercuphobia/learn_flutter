// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationModelImpl _$$NotificationModelImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationModelImpl(
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  date: DateTime.parse(json['date'] as String),
  description: json['description'] as String?,
  type: json['type'] as String? ?? 'chart',
  isRead: json['isRead'] as bool? ?? false,
);

Map<String, dynamic> _$$NotificationModelImplToJson(
  _$NotificationModelImpl instance,
) => <String, dynamic>{
  'title': instance.title,
  'subtitle': instance.subtitle,
  'date': instance.date.toIso8601String(),
  'description': instance.description,
  'type': instance.type,
  'isRead': instance.isRead,
};
