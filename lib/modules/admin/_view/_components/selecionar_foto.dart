import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SelecionarFotoWidget extends StatefulWidget {
  final void Function(File imagem) onImagePick;
  final String? urlImage;

  const SelecionarFotoWidget({
    super.key,
    required this.onImagePick,
    this.urlImage,
  });

  @override
  State<SelecionarFotoWidget> createState() => _SelecionarFotoWidgetState();
}

class _SelecionarFotoWidgetState extends State<SelecionarFotoWidget> {
  File? _image;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 500,
    );

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });

      widget.onImagePick(_image!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        Container(
          height: 120,
          width: 80,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(8),
            image: widget.urlImage != null || _image != null
                ? DecorationImage(
                    image: widget.urlImage != null
                        ? NetworkImage(widget.urlImage!)
                        : FileImage(_image!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _image == null && widget.urlImage == null
              ? Icon(
                  Icons.menu_book,
                  color: colorScheme.primary,
                  size: 60,
                )
              : null,
        ),
        TextButton.icon(
          onPressed: _pickImage,
          label: Text(
            'Adicionar Imagem',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          icon: const Icon(Icons.image),
        ),
      ],
    );
  }
}
