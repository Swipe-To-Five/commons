import 'package:json_annotation/json_annotation.dart';

part 'create_account.dto.g.dart';

@JsonSerializable()
class CreateAccountDto {
  @JsonKey(defaultValue: '')
  final String emailAddress;

  @JsonKey(defaultValue: '')
  final String password;

  @JsonKey(defaultValue: '')
  final String role;

  CreateAccountDto({
    required this.emailAddress,
    required this.password,
    required this.role,
  });

  factory CreateAccountDto.fromJson(Map<String, dynamic> json) =>
      _$CreateAccountDtoFromJson(json);

  toJson() => _$CreateAccountDtoToJson(this);
}
