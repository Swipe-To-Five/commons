// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_account.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAccountDto _$CreateAccountDtoFromJson(Map<String, dynamic> json) =>
    CreateAccountDto(
      emailAddress: json['emailAddress'] as String? ?? '',
      password: json['password'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );

Map<String, dynamic> _$CreateAccountDtoToJson(CreateAccountDto instance) =>
    <String, dynamic>{
      'emailAddress': instance.emailAddress,
      'password': instance.password,
      'role': instance.role,
    };
