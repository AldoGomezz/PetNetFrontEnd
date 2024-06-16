import 'package:dio/dio.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';

class OwnerDatasourceImpl extends OwnerDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiRest));

  @override
  Future<List<OwnerModel>> searchOwner(String token, String query) async {
    try {
      dio.options.headers["Authorization"] = token;

      final response = await dio.get('/owners/search?s=$query');

      final owners = response.data as List;

      return owners.map((owner) => OwnerModel.fromJson(owner)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<String> deleteOwner(String token, int id) async {
    try {
      dio.options.headers["Authorization"] = token;

      final response = await dio.delete('/owners/delete/$id');

      return response.data["message"];
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<String> registerOwner(String token, OwnerFormRequest request) async {
    try {
      dio.options.headers["Authorization"] = token;

      await dio.post(
        '/owners/register',
        data: request.toJson(),
      );

      return "Owner registered successfully";
      // return response.data["message"];
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<OwnerUpdateResponse> updateOwner(
      String token, int id, OwnerFormRequest request) async {
    try {
      dio.options.headers["Authorization"] = token;

      final response = await dio.put(
        '/owners/update/information/$id',
        data: request.toJson(),
      );

      return OwnerUpdateResponse.fromJson(response.data);
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<List<OwnerModel>> getOwners(String token) async {
    try {
      dio.options.headers["Authorization"] = token;

      final response = await dio.get('/owners/search?s=*');

      final owners = response.data as List;

      return owners.map((owner) => OwnerModel.fromJson(owner)).toList();
    } catch (e) {
      throw handleError(e);
    }
  }

  @override
  Future<OwnerModel> getOwner(String token, int id) async {
    try {
      dio.options.headers["Authorization"] = token;

      final response = await dio.get('/owners/get/information/$id');

      return OwnerModel.fromJson(
        response.data,
      );
    } catch (e) {
      throw handleError(e);
    }
  }
}
