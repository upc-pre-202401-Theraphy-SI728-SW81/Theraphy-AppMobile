import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_ffmpeg/flutter_ffmpeg.dart';
import 'package:path/path.dart';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String?> uploadImage(File image) async {
  try {
    // Obtener la referencia al almacenamiento de Firebase
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageReference = storage.ref().child('images/$fileName');

    print('Error al cargar la imagen: $storageReference');

    // Subir la imagen al almacenamiento de Firebase
    TaskSnapshot uploadTask = await storageReference.putFile(image);
    String imageUrl = await uploadTask.ref.getDownloadURL();

    // Retornar la URL de la imagen
    return imageUrl;
  } catch (e) {
    // Si ocurre un error, mostrar el mensaje de error y retornar null
    print('Error al cargar la imagen: $e');
    return null;
  }
}

Future<String?> uploadVideo(File video) async {
  try {
    final storage = FirebaseStorage.instance;
    String fileName = basename(video.path);
    Reference storageReference = storage.ref().child('videos/$fileName');

    // Convertir el video a formato MP4 con calidad y bitrate especificados .replaceAll(RegExp(r'\.\w+$'), '.mp4');
    final flutterFFmpeg = FlutterFFmpeg();
    final outputVideoPath = video.path;
    final cmd =
        '-i ${video.path} -c:v libx264 -b:v 1000k -c:a aac -b:a 128k $outputVideoPath';
    await flutterFFmpeg.execute(cmd);

    // Subir el video convertido al almacenamiento de Firebase
    UploadTask uploadTask = storageReference.putFile(File(outputVideoPath));
    await uploadTask;

    // Obtener la URL de descarga del video en formato MP4
    String videoUrl = await storageReference.getDownloadURL();

    // Retornar la URL del video
    return videoUrl;
  } catch (e) {
    print('Error al cargar el video: $e');
    return null;
  }
}
