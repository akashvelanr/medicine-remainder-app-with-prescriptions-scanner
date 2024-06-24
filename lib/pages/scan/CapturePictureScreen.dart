// ignore_for_file: unused_import

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CapturePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const CapturePictureScreen({Key? key, required this.camera}) : super(key: key);

  @override
  _CapturePictureScreenState createState() => _CapturePictureScreenState();
}

class _CapturePictureScreenState extends State<CapturePictureScreen> {
  late CameraController _controller;
  late FlashMode _flashMode = FlashMode.off;

  

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _controller.setFlashMode(FlashMode.off);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    try {
      _controller.setFlashMode(_flashMode);
      final XFile picture = await _controller.takePicture();
      Navigator.pop(context, picture.path);
    } catch (e) {
      print('Error taking picture: $e');
    }
  }


   void _toggleFlash() {
    setState(() {
      switch (_flashMode) {
        case FlashMode.off:
          _flashMode = FlashMode.torch;
          break;
        case FlashMode.torch:
          _flashMode = FlashMode.auto;
          break;
        case FlashMode.auto:
          _flashMode = FlashMode.off;
          break;
        case FlashMode.always:
          _flashMode = FlashMode.off;
          break;
      }
      _controller.setFlashMode(_flashMode);
      
    }
    
    
    );

    
  }

  IconData _getFlashIcon() {
     switch (_flashMode) {
      case FlashMode.off:
      return Icons.flash_off;
      case FlashMode.torch:
      return Icons.flash_on;
      case FlashMode.auto:
      return Icons.flash_auto;
      case FlashMode.always:
      return Icons.flash_off;
  }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Container();
    }
    return Scaffold(
      appBar: AppBar(title: Text('Capture Picture')),
      body: CameraPreview(_controller),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

         /* FloatingActionButton(
                onPressed: _toggleFlash,
                child: Icon(_getFlashIcon()),
                 ),
              const SizedBox(height: 16),  */



          FloatingActionButton(
               onPressed: _takePicture,
               child: Icon(Icons.camera),
            ),

             


             
        ],
      ),
    );
  }
}
