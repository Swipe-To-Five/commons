import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account.model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Account {
  @JsonKey(defaultValue: 0)
  @HiveField(1, defaultValue: 0)
  final int number;

  @JsonKey(defaultValue: '')
  @HiveField(2, defaultValue: '')
  final String emailAddress;

  @JsonKey(defaultValue: '')
  @HiveField(3, defaultValue: '')
  final String role;

  Account({
    required this.number,
    required this.emailAddress,
    required this.role,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  toJson() => _$AccountToJson(this);
}
