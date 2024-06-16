import 'package:dio/dio.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/auth/domain/domain.dart';

class AuthDatasourceImpl extends AuthDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiRest));

  @override
  Future<String> login(LoginRequest request) async {
    try {
      final response = await dio.post(
        '/auth/login',
        data: request.toJson(),
      );

      return response.data['token'];
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<String> register(RegisterRequest request) async {
    try {
      final response = await dio.post(
        '/auth/register',
        data: request.toJson(),
      );

      return response.data["message"];
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<String> renewToken(String token) async {
    try {
      dio.options.headers["Authorization"] = token;

      final response = await dio.get('/auth/renew_token');

      return response.data['token'];
    } catch (e) {
      throw handleError(e);
    }
  }
}
