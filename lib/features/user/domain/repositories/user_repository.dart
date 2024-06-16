import 'package:pet_net_app/features/user/domain/domain.dart';

abstract class UserRepository {
  Future<UserModel> getUser(String token);
}
