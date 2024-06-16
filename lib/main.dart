import 'package:pet_net_app/bootstrap.dart';
import 'core/core.dart';

void main() async {
  bootstrap(EnvType.prod, (cameras) => PetNetApp(cameras: cameras));
}
