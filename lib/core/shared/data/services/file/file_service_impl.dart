import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pet_net_app/core/core.dart';
import 'package:path/path.dart' as path;
import 'package:share_plus/share_plus.dart';

class FileServiceImpl extends FileService {
  @override
  Future<void> openFile(File file) async {
    try {
      /* final url = file.path;

      if (await file.exists()) {
        await OpenFile.open(url);
      } else {
        print('El archivo no existe: $url');
      } */

      await Share.shareXFiles([XFile(file.path)], text: "Compartir reporte");
    } catch (e) {
      throw CustomError(message: "Error al abrir archivo");
    }
  }

  @override
  Future<File> saveFile(Uint8List bytes, String fileName) async {
    try {
      PermissionStatus status = await Permission.storage.request();
      if (status.isGranted) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = path.join(dir.path, '$fileName.pdf');

        // Verifica si el directorio existe
        if (!await dir.exists()) {
          await dir.create(recursive: true);
        }
        final file = File(filePath);
        await file.writeAsBytes(bytes);
        return file;
      } else {
        throw CustomError(message: "Permiso denegado");
      }
    } catch (e) {
      throw CustomError(message: "Error al guardar");
    }
  }
}
