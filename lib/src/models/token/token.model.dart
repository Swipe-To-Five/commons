import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'token.model.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Token {
  @HiveField(0, defaultValue: '')
  @JsonKey(defaultValue: '')
  final String accessToken;

  @HiveField(1, defaultValue: '')
  @JsonKey(defaultValue: '')
  final String refreshToken;

  Token({
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  String toString() {
    return "Token { refreshToken: $refreshToken, accessToken: $accessToken}";
  }

  factory Token.fromJson(Map<String, dynamic> json) => _$TokenFromJson(json);

  toJson() => _$TokenToJson(this);
}
