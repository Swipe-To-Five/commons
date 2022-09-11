import 'package:commons/src/constants/constants.dart';
import 'package:commons/src/models/models.dart';
import 'package:hive/hive.dart';

class TokenService {
  final Box<Token> _tokenDb = Hive.box<Token>(TOKEN_BOX);

  static final TokenService _singleton = TokenService._internal();

  factory TokenService() {
    return _singleton;
  }

  TokenService._internal();

  void saveTokenToDevice(Token token) {
    log.i("Saving Token to Hive DB");
    _tokenDb.put(TOKEN, token);
    log.i("Saved Token to Hive DB");
  }

  Token fetchActivitiesFromDevice() {
    log.i("Fetching Token from Hive DB");
    return _tokenDb.get(
      TOKEN,
      defaultValue: Token(
        accessToken: '',
        refreshToken: '',
      ),
    )!;
  }
}
