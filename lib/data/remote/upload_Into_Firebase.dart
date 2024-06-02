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
  print("firs!");
  try {
    print("llego 0");
    final storage = FirebaseStorage.instance;
    print("llego 00");
    String fileName = basename(video.path);
    print("llego 000");
    Reference storageReference = storage.ref().child('videos/$fileName');

    print("llego 1");

    // Convertir el video a formato MP4 con calidad y bitrate especificados .replaceAll(RegExp(r'\.\w+$'), '.mp4');
    final flutterFFmpeg = FlutterFFmpeg();
    print("Ruta del archivo de video: ${video.path}");
    final outputVideoPath = video.path;
    print("Ruta del archivo de video2: ${video.path}");
    final cmd =
        '-i ${video.path} -c:v libx264 -b:v 1000k -c:a aac -b:a 128k $outputVideoPath';
    print("Ruta del archivo de video3: ${video.path}");

    await flutterFFmpeg.execute(cmd);

    print("llego 2");


    // Subir el video convertido al almacenamiento de Firebase
    UploadTask uploadTask = storageReference.putFile(File(outputVideoPath));
    print("llego 3.01");
    await uploadTask;

    print("llego 3");


    // Obtener la URL de descarga del video en formato MP4
    String videoUrl = await storageReference.getDownloadURL();

    print("llego 4");


    // Retornar la URL del video
    return videoUrl;
  } catch (e) {
    print('Error al cargar el video: $e');
    return null;
  }
}
