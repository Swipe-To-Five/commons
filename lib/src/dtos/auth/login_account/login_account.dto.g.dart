// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_account.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginAccountDto _$LoginAccountDtoFromJson(Map<String, dynamic> json) =>
    LoginAccountDto(
      emailAddress: json['emailAddress'] as String? ?? '',
      password: json['password'] as String? ?? '',
      platform: json['platform'] as String? ?? '',
    );

Map<String, dynamic> _$LoginAccountDtoToJson(LoginAccountDto instance) =>
    <String, dynamic>{
      'emailAddress': instance.emailAddress,
      'password': instance.password,
      'platform': instance.platform,
    };
