// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountAdapter extends TypeAdapter<Account> {
  @override
  final int typeId = 1;

  @override
  Account read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Account(
      number: fields[1] == null ? 0 : fields[1] as int,
      emailAddress: fields[2] == null ? '' : fields[2] as String,
      role: fields[3] == null ? '' : fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeByte(3)
      ..writeByte(1)
      ..write(obj.number)
      ..writeByte(2)
      ..write(obj.emailAddress)
      ..writeByte(3)
      ..write(obj.role);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      number: json['number'] as int? ?? 0,
      emailAddress: json['emailAddress'] as String? ?? '',
      role: json['role'] as String? ?? '',
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'number': instance.number,
      'emailAddress': instance.emailAddress,
      'role': instance.role,
    };
