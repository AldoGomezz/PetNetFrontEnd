import 'package:pet_net_app/features/owner/data/data.dart';
import 'package:pet_net_app/features/owner/domain/domain.dart';

class OwnerRepositoryImpl extends OwnerRepository {
  final OwnerDatasource datasource;

  OwnerRepositoryImpl({OwnerDatasource? datasource})
      : datasource = datasource ?? OwnerDatasourceImpl();

  @override
  Future<List<OwnerModel>> searchOwner(String token, String query) {
    return datasource.searchOwner(token, query);
  }

  @override
  Future<String> deleteOwner(String token, int id) {
    return datasource.deleteOwner(token, id);
  }

  @override
  Future<String> registerOwner(String token, OwnerFormRequest request) {
    return datasource.registerOwner(token, request);
  }

  @override
  Future<OwnerUpdateResponse> updateOwner(
      String token, int id, OwnerFormRequest request) {
    return datasource.updateOwner(token, id, request);
  }

  @override
  Future<List<OwnerModel>> getOwners(String token) {
    return datasource.getOwners(token);
  }

  @override
  Future<OwnerModel> getOwner(String token, int id) {
    return datasource.getOwner(token, id);
  }
}
