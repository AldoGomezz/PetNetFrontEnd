import 'package:dio/dio.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/user/domain/domain.dart';

class UserDatasourceImpl extends UserDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiRest));

  @override
  Future<UserModel> getUser(String token) async {
    try {
      dio.options.headers["Authorization"] = token;

      final response = await dio.get('/users/information');

      return UserModel.fromJson(response.data);
    } catch (e) {
      throw handleError(e);
    }
  }
}
