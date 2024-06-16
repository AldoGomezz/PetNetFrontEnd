import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvType { dev, prod }

class Environment {
  static Future<void> initEnvironment(EnvType envType) async {
    await dotenv.load(fileName: ".env");

    switch (envType) {
      case EnvType.dev:
        apiRest = dotenv.env["API_REST_PRUEBAS"] ??
            "No está configurado el API_REST_PRUEBAS";
        break;
      case EnvType.prod:
        apiRest = dotenv.env["API_REST"] ?? "No está configurado el API_REST";
        break;
    }

    socketUrl = dotenv.env["SOCKET_URL"] ?? "No está configurado el SOCKET_URL";
  }

  static String apiRest = '';
  static String socketUrl = '';
}
