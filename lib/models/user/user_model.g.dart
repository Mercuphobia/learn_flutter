// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      profession: json['profession'] as String,
      email: json['email'] as String,
      dateOfBirth: DateTime.parse(json['dateOfBirth'] as String),
      location: json['location'] as String,
      avatarUrl: json['avatarUrl'] as String,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profession': instance.profession,
      'email': instance.email,
      'dateOfBirth': instance.dateOfBirth.toIso8601String(),
      'location': instance.location,
      'avatarUrl': instance.avatarUrl,
    };
