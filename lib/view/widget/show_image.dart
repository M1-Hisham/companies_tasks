import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ShowImage extends StatefulWidget {
  const ShowImage({super.key, required this.imagefile});
  final File imagefile;

  @override
  State<ShowImage> createState() => _ShowImageState();
}

class _ShowImageState extends State<ShowImage> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              'Please choose an option',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: imageCamera,
              child: const Row(
                children: [
                  Icon(
                    Icons.camera,
                    size: 27,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Camera',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: imageGallery,
              child: const Row(
                children: [
                  Icon(
                    Icons.photo,
                    size: 27,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Text(
                    'Gallery',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void imageCamera() async {
    await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
  }

  void imageGallery() async {
    var xFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    widget.imagefile != File(xFile!.path);
  }
}
