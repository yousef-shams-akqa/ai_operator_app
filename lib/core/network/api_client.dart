
abstract class ApiClient {

  final String baseUrl;
  final ApiClientOptions? options;
  ApiClient({ required this.baseUrl, this.options });


  Future<Map<String,dynamic>> get(String path, { Map<String,dynamic>? queryParameters });

  Future<Map<String,dynamic>> post(String path, { Map<String,dynamic>? data });

  Future<Map<String,dynamic>> put(String path, { Map<String,dynamic>? data });

  Future<Map<String,dynamic>> delete(String path, { Map<String,dynamic>? data });
}

class ApiClientOptions {
  final Map<String, dynamic> headers;
  final Duration sendTimeout;
  final Duration receiveTimeout;

  ApiClientOptions({ required this.headers, required this.sendTimeout, required this.receiveTimeout });
}