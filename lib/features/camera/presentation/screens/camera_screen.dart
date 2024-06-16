import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pet_net_app/features/predict/presentation/presentation.dart';

class CameraScreen extends ConsumerStatefulWidget {
  static const String routerPantalla = 'camera-screen';

  final List<CameraDescription> cameras;
  const CameraScreen({super.key, required this.cameras});

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends ConsumerState<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  FlashMode _flashMode = FlashMode.off;

  int _currentCameraIndex = 0;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initilizeCamera();
  }

  void _initilizeCamera() {
    _controller = CameraController(
      widget.cameras[_currentCameraIndex],
      ResolutionPreset.high,
      imageFormatGroup: ImageFormatGroup.jpeg,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Handle access errors here.
            break;
          default:
            // Handle other errors here.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Vista previa de la cámara
          Container(
            margin: EdgeInsets.only(top: size.height * 0.1),
            child: CameraPreview(_controller),
          ),
          // Botones de cerrar y flash
          _topOptions(size, context),
          // Botones de captura, cambio de cámara y galería
          _bottomOptions(context, _isLoading),
        ],
      ),
    );
  }

  Positioned _bottomOptions(
    BuildContext context,
    bool isLoading,
  ) {
    return Positioned(
      bottom: 18.0,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón de galería
            GestureDetector(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Icon(
                  Icons.photo,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
            // Botón de captura
            Stack(
              children: [
                //Borde circular
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                  ),
                ),
                // Circulo central
                Positioned.fill(
                  child: GestureDetector(
                    onTap: isLoading
                        ? null
                        : () async {
                            setState(() {
                              _isLoading = true;
                            });
                            // Asegura de esperar a que la cámara esté lista antes de tomar una foto.
                            await _initializeControllerFuture;

                            await _controller.setFlashMode(_flashMode);

                            final XFile file = await _controller.takePicture();

                            _controller.setFlashMode(FlashMode.off);

                            setState(() {
                              _isLoading = false;
                            });

                            if (context.mounted) {
                              ref.read(predictProvider.notifier).logout();
                              context.pop();
                              context.push("/predict", extra: file);
                            }
                            // Obtén el tamaño del archivo en MB
                            /* final fileSizeInBytes =
                              File(file.path).lengthSync();
                          final fileSizeInMB =
                              fileSizeInBytes / (1024 * 1024);
                          print('Tamaño del archivo: $fileSizeInMB MB'); */
                          },
                    child: Container(
                      margin: const EdgeInsets.all(11.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isLoading
                            ? Theme.of(context).colorScheme.primary
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Botón de cambio de cámara
            GestureDetector(
              onTap: () {
                setState(() {
                  _currentCameraIndex =
                      (_currentCameraIndex + 1) % widget.cameras.length;
                });
                _initilizeCamera();
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.5),
                ),
                child: const Icon(
                  Icons.cached,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Positioned _topOptions(Size size, BuildContext context) {
    return Positioned(
      top: size.height * 0.1,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Botón de cerrar
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 25,
              ),
            ),
            // Botón de flash
            GestureDetector(
              onTap: () {
                setState(() {
                  // Cambia el modo de flash cada vez que se toca el botón
                  _flashMode = _flashMode == FlashMode.off
                      ? FlashMode.torch
                      : FlashMode.off;
                  // Aplica el nuevo modo de flash
                  _controller.setFlashMode(_flashMode);
                });
              },
              child: Icon(
                _flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on,
                color: Colors.white,
                size: 25,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
