import 'package:pet_net_app/features/profile/domain/domain.dart';

abstract class ProfileDatasource {
  Future<String> updateUserInfo(
    String token,
    UpdateInfoRequest request,
  );
}
