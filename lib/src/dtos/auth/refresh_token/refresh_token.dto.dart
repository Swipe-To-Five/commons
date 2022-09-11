import 'package:json_annotation/json_annotation.dart';

part 'refresh_token.dto.g.dart';

@JsonSerializable()
class RefreshTokenDto {
  @JsonKey(defaultValue: '')
  final String refreshToken;

  RefreshTokenDto({
    required this.refreshToken,
  });

  factory RefreshTokenDto.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenDtoFromJson(json);

  toJson() => _$RefreshTokenDtoToJson(this);
}
