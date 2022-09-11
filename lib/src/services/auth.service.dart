import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:commons/src/constants/constants.dart';
import 'package:commons/src/dtos/dto.dart';
import 'package:commons/src/enums/enums.dart';
import 'package:commons/src/exceptions/exceptions.dart';
import 'package:commons/src/models/models.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class AuthService {
  final Box<Account> _accountDb = Hive.box<Account>(LOGGED_IN_USER_BOX);

  /*
   * Service Implementation for account registration.
   * @param createAccountDto DTO Implementation for account registration.
   */
  Future<Account> registerNewAccount(CreateAccountDto createAccountDto) async {
    try {
      // Fetch user details from the server
      Response response = await serverDevApi.publicApi.get(
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
