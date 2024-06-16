import 'package:dio/dio.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/profile/domain/domain.dart';

class ProfileDatasourceImpl extends ProfileDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiRest));

  @override
  Future<String> updateUserInfo(
    String token,
    UpdateInfoRequest request,
  ) async {
    try {
      dio.options.headers["Authorization"] = token;

      final response = await dio.put(
        "/users/update/information",
        data: request.toJson(),
      );

      return response.data["message"];
    } catch (e) {
      throw handleError(e);
    }
  }
}
