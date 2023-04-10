import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _storedImage;

  Future<void> _picker() async {
    final ImagePicker picker = ImagePicker();
    final image =
        await picker.pickImage(source: ImageSource.camera, maxWidth: 600);

    if (image == null) return;
    setState(() {
      _storedImage = File(image.path);
    });

    final appDir = await syspaths
        .getApplicationDocumentsDirectory(); //gets directory of app
    final fileName = path
        .basename(_storedImage!.path); //get file name given by device camera
    final savedImage = await _storedImage!
        .copy('${appDir.path}/$fileName'); //gives final file location
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Colors.grey,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          alignment: Alignment.center,
          child: _storedImage != null
              ? Image.file(
                  _storedImage!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : const Text(
                  'No Image Picked',
                  textAlign: TextAlign.center,
                ),
        ),
        Expanded(
          child: TextButton.icon(
            onPressed: _picker,
            icon: const Icon(Icons.camera),
            label: const Text('Pick image'),
            style: TextButton.styleFrom(),
          ),
        )
      ],
    );
  }
}
