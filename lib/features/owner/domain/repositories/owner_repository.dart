import 'package:pet_net_app/features/owner/domain/domain.dart';

abstract class OwnerRepository {
  Future<OwnerModel> getOwner(String token, int id);
  Future<String> registerOwner(String token, OwnerFormRequest request);
  Future<OwnerUpdateResponse> updateOwner(
    String token,
    int id,
    OwnerFormRequest request,
  );
  Future<String> deleteOwner(String token, int id);
  Future<List<OwnerModel>> getOwners(String token);
  Future<List<OwnerModel>> searchOwner(String token, String query);
}
