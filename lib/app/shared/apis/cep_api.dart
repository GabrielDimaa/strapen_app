import 'package:dio/dio.dart';
import 'package:strapen_app/app/shared/apis/dio_default.dart';

abstract class CepApi {
  static const String _baseUrl = "https://viacep.com.br/ws/";

  static Future<Map<String, dynamic>> get(String url) async {
    try {
      final Dio _dio = DioDefault.getInstance(baseUrl: _baseUrl);
      final Response? response = await _dio.get(url);

      if (response == null) throw Exception();

      if (response.data['erro'] ?? false)
        throw Exception("CEP inválido!");

      return response.data;
    } on DioError catch (_) {
      throw Exception("Houve um erro ao buscar o CEP.\nVerifique a conexão da internet.");
    } catch (e) {
      throw Exception(e);
    }
  }
}