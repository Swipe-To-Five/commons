import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:commons/src/constants/constants.dart';
import 'package:commons/src/dtos/dto.dart';
import 'package:commons/src/enums/enums.dart';
import 'package:commons/src/exceptions/exceptions.dart';
import 'package:commons/src/models/models.dart';
import 'package:commons/src/services/services.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class AuthService {
  final Box<Account> _accountDb = Hive.box<Account>(LOGGED_IN_USER_BOX);
  final TokenService _tokenService = TokenService();

  /*
   * Service Implementation for fetching logged in user details.
   */
  Future<Account> fetchLoggedInAccount() async {
    try {
      // Send request to server to fetch logged in account.
      Response response = await serverDevApi.securedApi.get(
        "v1/account",
      );

      // Handling Errors.
      if (response.statusCode! >= 400 && response.statusCode! < 500) {
        Map<String, dynamic> body = json.decode(response.data);
        throw AuthException(
            message: AuthError.values.firstWhere((error) =>
                error.toString().substring("AuthError.".length) ==
                body['message']));
      } else if (response.statusCode! >= 500) {
        Map<String, dynamic> body = json.decode(response.data);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Decoding account from JSON.
      Account account = Account.fromJson(json.decode(response.data));

      // Saving account details to storage.
      syncAccountToOfflineDb(account);

      // Returning account.
      return account;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      // Fetch account from Offline Storage.
      Account? dbAccount = fetchAccountFromOfflineDb();

      // Return account if logged in else throw error.
      if (dbAccount != null) {
        return dbAccount;
      } else {
        throw AuthException(
          message: AuthError.UNAUTHENTICATED,
        );
      }
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      // Fetch account from Offline Storage.
      Account? dbAccount = fetchAccountFromOfflineDb();

      // Return account if logged in else throw error.
      if (dbAccount != null) {
        return dbAccount;
      } else {
        throw AuthException(
          message: AuthError.UNAUTHENTICATED,
        );
      }
    }
  }

  /*
   * Service Implementation for account registration.
   * @param createAccountDto DTO Implementation for account registration.
   */
  Future<Account> registerNewAccount(CreateAccountDto createAccountDto) async {
    try {
      // Send request to server to register new account.
      Response response = await serverDevApi.publicApi.post(
        "v1/account",
        data: createAccountDto.toJson(),
      );

      // Handling Errors.
      if (response.statusCode! >= 400 && response.statusCode! < 500) {
        Map<String, dynamic> body = json.decode(response.data);
        throw AuthException(
            message: AuthError.values.firstWhere((error) =>
                error.toString().substring("AuthError.".length) ==
                body['message']));
      } else if (response.statusCode! >= 500) {
        Map<String, dynamic> body = json.decode(response.data);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Decoding account from JSON.
      Account account = Account.fromJson(json.decode(response.data));

      // Saving account details to storage.
      syncAccountToOfflineDb(account);

      // Returning account.
      return account;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      // Fetch account from Offline Storage.
      Account? dbAccount = fetchAccountFromOfflineDb();

      // Return account if logged in else throw error.
      if (dbAccount != null) {
        return dbAccount;
      } else {
        throw AuthException(
          message: AuthError.UNAUTHENTICATED,
        );
      }
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      // Fetch account from Offline Storage.
      Account? dbAccount = fetchAccountFromOfflineDb();

      // Return account if logged in else throw error.
      if (dbAccount != null) {
        return dbAccount;
      } else {
        throw AuthException(
          message: AuthError.UNAUTHENTICATED,
        );
      }
    }
  }

  /*
   * Service Implementation for account login.
   * @param loginAccountDto DTO Implementation for account login.
   */
  Future<Token> loginAccount(LoginAccountDto loginAccountDto) async {
    try {
      // Send request to server for login tokens.
      Response response = await serverDevApi.publicApi.post(
        "v1/auth/login",
        data: loginAccountDto.toJson(),
      );

      // Handling Errors.
      if (response.statusCode! >= 400 && response.statusCode! < 500) {
        Map<String, dynamic> body = json.decode(response.data);
        throw AuthException(
            message: AuthError.values.firstWhere((error) =>
                error.toString().substring("AuthError.".length) ==
                body['message']));
      } else if (response.statusCode! >= 500) {
        Map<String, dynamic> body = json.decode(response.data);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Decoding tokens from JSON.
      Token token = Token.fromJson(json.decode(response.data));

      // Saving tokens to storage.
      _tokenService.saveTokenToDevice(token);

      // Returning token.
      return token;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      throw GeneralException(
        message: GeneralError.OFFLINE,
      );
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      throw GeneralException(
        message: GeneralError.OFFLINE,
      );
    }
  }

  /*
   * Service Implementation for refreshing access token.
   * @param refreshTokenDto DTO Implementation for refreshing access token.
   */
  Future<Token> refreshTokens(RefreshTokenDto refreshTokenDto) async {
    try {
      // Send request to server for refreshing tokens.
      Response response = await serverDevApi.publicApi.post(
        "v1/auth/refresh",
        data: refreshTokenDto.toJson(),
      );

      // Handling Errors.
      if (response.statusCode! >= 400 && response.statusCode! < 500) {
        Map<String, dynamic> body = json.decode(response.data);
        throw AuthException(
            message: AuthError.values.firstWhere((error) =>
                error.toString().substring("AuthError.".length) ==
                body['message']));
      } else if (response.statusCode! >= 500) {
        Map<String, dynamic> body = json.decode(response.data);

        log.e(body["message"]);

        throw GeneralException(
          message: GeneralError.SOMETHING_WENT_WRONG,
        );
      }

      // Decoding tokens from JSON.
      Token token = Token.fromJson(json.decode(response.data));

      // Saving tokens to storage.
      _tokenService.saveTokenToDevice(token);

      // Returning token.
      return token;
    } on SocketException {
      log.wtf("Dedicated Server Offline");

      throw GeneralException(
        message: GeneralError.OFFLINE,
      );
    } on TimeoutException {
      log.wtf("Dedicated Server Offline");

      throw GeneralException(
        message: GeneralError.OFFLINE,
      );
    }
  }

  /*
   * Service implementation for saving user in offline storage.
   */
  void syncAccountToOfflineDb(Account account) {
    log.i("Saving account to Hive DB");
    _accountDb.put(LOGGED_IN_USER, account);
    log.i("Saved account to Hive DB");
  }

  /*
   * Service implementation for fetching user from offline storage.
   */
  Account? fetchAccountFromOfflineDb() {
    log.i("Fetching account from Hive DB");
    return _accountDb.get(LOGGED_IN_USER);
  }
}
