import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:mobile_app_theraphy/data/remote/upload_Into_Firebase.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget { 
  const UploadPage({super.key});

  @override
  State<UploadPage> createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  VideoPlayerController? _videoController;
  String? _videoUrl;
  File? _videoFile;

  Future<void> _pickVideo() async {
    final imagePicker = ImagePicker();
    final pickedVideo = await imagePicker.getVideo(source: ImageSource.gallery);

    if (pickedVideo != null) {
      final videoFile = File(pickedVideo.path);
      final videoUrl = await uploadVideo(videoFile);
      print("hola");
      setState(() {
        _videoFile = videoFile;
        _videoController = VideoPlayerController.file(_videoFile!);
        _videoController!.initialize();
        _videoUrl = videoUrl;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carga y Reproducción de Video'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                _pickVideo();
              },
              child: Text('Seleccionar Video'),
            ),
            if (_videoController != null)
              AspectRatio(
                aspectRatio: _videoController!.value.aspectRatio,
                child: VideoPlayer(_videoController!),
              ),
            if (_videoUrl != null)
              Text('URL del Video en Firebase Storage: $_videoUrl'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }
}