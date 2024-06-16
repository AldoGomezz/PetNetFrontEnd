import 'package:image_picker/image_picker.dart';
import 'camera_gallery_service.dart';

class CameraGalleryServiceImpl extends CameraGalleryService {
  final ImagePicker _picker = ImagePicker();
  @override
  Future<XFile?> selectPhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (photo == null) return null;
    return photo;
  }

  @override
  Future<XFile?> takePhoto() async {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (photo == null) return null;

    return photo;
  }

  @override
  Future<String?> selectVideo() async {
    final XFile? video = await _picker.pickVideo(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.rear,
    );
    if (video == null) return null;

    return video.path;
  }
}
