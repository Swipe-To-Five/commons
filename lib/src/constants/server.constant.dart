import 'package:commons/src/constants/logger.constant.dart';
import 'package:dio/dio.dart';

class Api {
  late final Dio publicApi;

  late final Dio securedApi;

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
        // Attach Access Tokens Here...

        return handler.next(options);
      }),
    );
  }
}

final serverDevApi = Api(apiUrl: "http://10.0.2.2:5000/api");
