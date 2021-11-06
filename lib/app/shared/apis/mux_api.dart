import 'dart:convert';

import 'package:camera_with_rtmp/camera.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:strapen_app/app/modules/live/models/live_model.dart';
import 'package:strapen_app/app/shared/apis/dio_default.dart';

abstract class MuxApi {
  static const String _baseUrl = "https://api.mux.com/video/v1/live-streams/";
  static const String _baseUrlRmtp = "rtmps://global-live.mux.com:443/app/";

  static String urlStream(String playbackId) => "https://stream.mux.com/$playbackId.m3u8";
  static String urlImageLive(String playbackId, {required int width, required int height}) =>
      "https://image.mux.com/$playbackId/thumbnail.png?width=$width&height=$height&fit_mode=smartcrop&time=10";

  static Future<Map<String, dynamic>?> post(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
    bool hasAuth = true,
  }) async {
    final Map<String, dynamic> headersAuth = {};
    if (hasAuth)
      headersAuth.addAll(await _getAuth());

    try {
      final Dio _dio = DioDefault.getInstance(baseUrl: _baseUrl, headers: headers, headersAuth: headersAuth);
      final Response? response = await _dio.post(url, data: data);

      if (response == null) throw Exception();

      return response.data['data'] ?? response.data;
    } on DioError catch (_) {
      _throw();
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    bool hasAuth = false,
  }) async {
    final Map<String, dynamic> headersAuth = {};
    if (!hasAuth)
      headersAuth.addAll(await _getAuth());

    try {
      final Dio _dio = DioDefault.getInstance(baseUrl: _baseUrl, headers: headers, headersAuth: headersAuth);
      final Response? response = await _dio.get(url, queryParameters: queryParameters);

      if (response == null) throw Exception();

      return response.data;
    } on DioError catch (_) {
      _throw();
    } catch (e) {
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> put(
      String url, {
        Map<String, dynamic>? data,
        Map<String, dynamic>? headers,
        bool hasAuth = true,
      }) async {
    final Map<String, dynamic> headersAuth = {};
    if (hasAuth)
      headersAuth.addAll(await _getAuth());

    try {
      final Dio _dio = DioDefault.getInstance(baseUrl: _baseUrl, headers: headers, headersAuth: headersAuth);
      final Response? response = await _dio.put(url, data: data);

      if (response == null) throw Exception();

      return response.data['data'] ?? response.data;
    } on DioError catch (_) {
      _throw();
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> startLive(LiveModel model, CameraController cameraController) async {
    if (!cameraController.value.isInitialized)
      throw Exception("Houve um erro ao utilizar sua câmera.");

    await cameraController.startVideoStreaming(_baseUrlRmtp + model.streamKey!);
  }

  static Future<Map<String, dynamic>> _getAuth() async {
    await dotenv.load(fileName: ".env");
    return {"authorization": "Basic " + base64Encode(utf8.encode("${dotenv.env['MUX_TOKEN_ID']}:${dotenv.env['MUX_TOKEN_SECRET']}"))};
  }

  static void _throw() {
    throw Exception("Houve um erro ao realizar a requisição.\nVerifique a conexão da internet.");
  }
}
