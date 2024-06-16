import 'dart:io';
import 'dart:typed_data';

abstract class FileService {
  Future<File> saveFile(Uint8List bytes, String fileName);
  Future<void> openFile(File file);
}
