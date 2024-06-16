import 'package:pet_net_app/features/user/data/data.dart';
import 'package:pet_net_app/features/user/domain/domain.dart';

class UserRepositoryImpl extends UserRepository {
  final UserDatasource userDatasource;

  UserRepositoryImpl({UserDatasource? userDatasource})
      : userDatasource = userDatasource ?? UserDatasourceImpl();

  @override
  Future<UserModel> getUser(String token) {
    return userDatasource.getUser(token);
  }
}
