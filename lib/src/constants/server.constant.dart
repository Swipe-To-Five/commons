import 'package:commons/src/constants/logger.constant.dart';
import 'package:dio/dio.dart';

class Api {
  final Dio publicApi = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:5000/",
      connectTimeout: 5000,
      receiveTimeout: 5000,
    ),
  );

  final Dio securedApi = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:5000/",
      connectTimeout: 5000,
      receiveTimeout: 5000,
    ),
  );

  Api() {
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

final serverApi = Api();
