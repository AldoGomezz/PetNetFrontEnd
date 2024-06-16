import 'package:pet_net_app/features/auth/data/data.dart';
import 'package:pet_net_app/features/auth/domain/domain.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDatasource datasource;

  AuthRepositoryImpl({AuthDatasource? datasource})
      : datasource = datasource ?? AuthDatasourceImpl();

  @override
  Future<String> login(LoginRequest request) {
    return datasource.login(request);
  }

  @override
  Future<String> register(RegisterRequest request) {
    return datasource.register(request);
  }

  @override
  Future<String> renewToken(String token) {
    return datasource.renewToken(token);
  }
}
