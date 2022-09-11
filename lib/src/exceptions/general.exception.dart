import 'package:commons/src/enums/enums.dart';

class GeneralException implements Exception {
  GeneralError message;

  GeneralException({
    required this.message,
  });

  @override
  String toString() {
    return message.toString();
  }
}
