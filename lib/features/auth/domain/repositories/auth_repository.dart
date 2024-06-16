import 'package:pet_net_app/features/auth/domain/domain.dart';

abstract class AuthRepository {
  Future<String> login(LoginRequest request);
  Future<String> register(RegisterRequest request);
  Future<String> renewToken(String token);
}
