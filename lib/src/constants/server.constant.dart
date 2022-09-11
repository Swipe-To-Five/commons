import 'package:commons/src/constants/logger.constant.dart';
import 'package:commons/src/models/models.dart';
import 'package:commons/src/services/services.dart';
import 'package:dio/dio.dart';

class Api {
  late final Dio publicApi;

  late final Dio securedApi;

  final TokenService _tokenService = TokenService();

  Api({required String apiUrl}) {
    publicApi = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: 5000,
        receiveTimeout: 5000,
      ),
    );

    securedApi = Dio(
      BaseOptions(
        baseUrl: apiUrl,
        connectTimeout: 5000,
        receiveTimeout: 5000,
      ),
    );

    securedApi.interceptors.add(
      InterceptorsWrapper(onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          log.i('Access Token Expired');
          // Handle Token Refresh Here...

        } else {
          handler.next(error);
        }
      }, onRequest: (options, handler) {
        Token token = _tokenService.fetchActivitiesFromDevice();

        if (token.accessToken.isNotEmpty) {
          options.headers['Authorization'] = "Bearer ${token.accessToken}";
        }

        return handler.next(options);
      }),
    );
  }
}

final serverDevApi = Api(apiUrl: "http://10.0.2.2:5000/api");
