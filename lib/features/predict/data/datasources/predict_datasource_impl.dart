import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:pet_net_app/features/predict/domain/domain.dart';

class PredictDatasourceImpl extends PredictDatasource {
  final dio = Dio(BaseOptions(baseUrl: Environment.apiRest));

  @override
  Future<PredictModel> predict(
    String token,
    Uint8List image,
    String imageName,
  ) async {
    try {
      dio.options.headers["Authorization"] = token;

      final formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(
          image,
          filename: imageName,
        ),
      });

      final response = await dio.post(
        "/resnet/predict",
        data: formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );

      final predictModel = PredictModel.fromJson(response.data);

      return predictModel;
    } catch (e) {
      throw handleError(e);
    }
  }
}
