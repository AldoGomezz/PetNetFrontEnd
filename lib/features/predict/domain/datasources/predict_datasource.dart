import 'dart:typed_data';

import 'package:pet_net_app/features/predict/domain/domain.dart';

abstract class PredictDatasource {
  Future<PredictModel> predict(
    String token,
    Uint8List image,
    String imageName,
  );
}
