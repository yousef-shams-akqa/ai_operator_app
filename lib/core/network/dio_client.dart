import 'package:ai_operator_app/core/network/api_client.dart';
import 'package:dio/dio.dart';

class DioClient implements ApiClient {
  @override
  final String baseUrl;

  @override
  final ApiClientOptions? options;

  late final Dio dio;

  DioClient({ required this.baseUrl, this.options }) {

    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      headers: options?.headers ?? { 'Content-Type': 'application/json' },
      sendTimeout: options?.sendTimeout ?? const Duration(seconds: 5),
      receiveTimeout: options?.receiveTimeout ?? const Duration(seconds: 3),
    );

    dio = Dio(baseOptions);
  }

  @override
  Future<Map<String, dynamic>> delete(String path, {Map<String, dynamic>? data}) async {
    final response = await dio.delete(path, data: data);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParameters}) async {
    final response = await dio.get(path, queryParameters: queryParameters);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? data}) async {
    final response = await dio.post(path, data: data);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? data}) async {
    final response = await dio.put(path, data: data);
    return response.data;
  }


}