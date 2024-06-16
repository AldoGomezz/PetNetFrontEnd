import 'dart:typed_data';

import 'package:pet_net_app/features/predict/data/data.dart';
import 'package:pet_net_app/features/predict/domain/domain.dart';

class PredictRepositoryImpl extends PredictRepository {
  final PredictDatasource datasource;

  PredictRepositoryImpl({PredictDatasource? datasource})
      : datasource = PredictDatasourceImpl();

  @override
  Future<PredictModel> predict(
      String token, Uint8List image, String imageName) {
    return datasource.predict(token, image, imageName);
  }
}
