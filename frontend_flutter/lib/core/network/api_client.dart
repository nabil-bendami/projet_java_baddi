import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiClient {
  static const String baseUrl = kIsWeb
      ? "http://localhost:8080" // Pour web
      : "http://10.0.2.2:8080"; // Pour Android Emulator

  late final Dio _dio;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Intercepteur pour gérer les erreurs
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Ajouter le token JWT si disponible
          final token = _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          debugPrint('🌐 REQUEST: ${options.method} ${options.uri}');
          debugPrint('📤 DATA: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          debugPrint('✅ RESPONSE: ${response.statusCode} ${response.data}');
          return handler.next(response);
        },
        onError: (DioException error, handler) {
          debugPrint('❌ ERROR: ${error.response?.statusCode} ${error.message}');
          debugPrint('📄 ERROR DATA: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );
  }

  // Méthode pour obtenir le token (à implémenter avec stockage sécurisé)
  String? _getToken() {
    // TODO: Implémenter avec flutter_secure_storage
    return null; // Pour l'instant, pas de token
  }

  // Méthode pour définir le token
  void setToken(String token) {
    // TODO: Sauvegarder le token de manière sécurisée
    debugPrint('🔑 Token set: ${token.substring(0, 20)}...');
  }

  // Méthode pour supprimer le token
  void clearToken() {
    // TODO: Supprimer le token du stockage
    debugPrint('🔑 Token cleared');
  }

  // GET request
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    return _dio.get(path, queryParameters: queryParameters);
  }

  // POST request
  Future<Response> post(String path, {dynamic data}) async {
    return _dio.post(path, data: data);
  }

  // PUT request
  Future<Response> put(String path, {dynamic data}) async {
    return _dio.put(path, data: data);
  }

  // DELETE request
  Future<Response> delete(String path) async {
    return _dio.delete(path);
  }

  // Test de connexion
  Future<bool> testConnection() async {
    try {
      final response = await get('/api/health');
      return response.statusCode == 200 && response.data == 'OK';
    } catch (e) {
      debugPrint('❌ Connection test failed: $e');
      return false;
    }
  }
}
