import 'package:pet_net_app/features/profile/data/data.dart';
import 'package:pet_net_app/features/profile/domain/domain.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  final ProfileDatasource datasource;

  ProfileRepositoryImpl({ProfileDatasource? datasource})
      : datasource = ProfileDatasourceImpl();

  @override
  Future<String> updateUserInfo(
    String token,
    UpdateInfoRequest request,
  ) {
    return datasource.updateUserInfo(token, request);
  }
}
