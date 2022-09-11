import 'package:json_annotation/json_annotation.dart';

part 'login_account.dto.g.dart';

@JsonSerializable()
class LoginAccountDto {
  @JsonKey(defaultValue: '')
  final String emailAddress;

  @JsonKey(defaultValue: '')
  final String password;

  @JsonKey(defaultValue: '')
  final String platform;

  LoginAccountDto({
    required this.emailAddress,
    required this.password,
    required this.platform,
  });

  factory LoginAccountDto.fromJson(Map<String, dynamic> json) =>
      _$LoginAccountDtoFromJson(json);

  toJson() => _$LoginAccountDtoToJson(this);
}
