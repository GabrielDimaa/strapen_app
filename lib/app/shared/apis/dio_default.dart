import 'package:dio/dio.dart';

abstract class DioDefault {
  static Dio getInstance({
    String? baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? headersAuth,
  }) {
    final Map<String, dynamic> headersParams = {};

    if (headers != null)
      headersParams.addAll(headers);
    if (headersAuth != null)
      headersParams.addAll(headersAuth);

    return Dio(
      BaseOptions(
        connectTimeout: 5000,
        receiveTimeout: 5000,
        sendTimeout: 5000,
        baseUrl: baseUrl ?? "",
        queryParameters: queryParameters,
        headers: headersParams,
      ),
    );
  }
}
