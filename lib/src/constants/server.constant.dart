import 'package:commons/src/constants/logger.constant.dart';
import 'package:commons/src/models/models.dart';
import 'package:commons/src/services/services.dart';
import 'package:commons/src/dtos/dto.dart';
import 'package:dio/dio.dart';

class Api {
  late final Dio publicApi;

  late final Dio securedApi;

  final TokenService _tokenService = TokenService();
  final AuthService _authService = AuthService();

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
          Token token = _tokenService.fetchTokensFromDevice();
          RefreshTokenDto refreshTokenDto = RefreshTokenDto(
            refreshToken: token.refreshToken,
          );

          _authService
              .refreshTokens(refreshTokenDto)
              .then((_) => _retry(error.requestOptions))
              .then((response) => handler.resolve(response))
              .catchError(
            (error, stackTrace) {
              log.e(
                "Dio Interceptor Error",
                error,
                stackTrace,
              );
              handler.next(error);
            },
          );
        } else {
          handler.next(error);
        }
      }, onRequest: (options, handler) {
        Token token = _tokenService.fetchTokensFromDevice();

        if (token.accessToken.isNotEmpty) {
          options.headers['Authorization'] = "Bearer ${token.accessToken}";
        }

        return handler.next(options);
      }),
    );
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return securedApi.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}

final serverDevApi = Api(apiUrl: "http://10.0.2.2:5000/api");
