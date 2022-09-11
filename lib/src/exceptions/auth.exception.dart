import 'package:commons/src/enums/enums.dart';

class AuthException implements Exception {
  AuthError message;

  AuthException({
    required this.message,
  });

  @override
  String toString() {
    return message.toString();
  }
}
