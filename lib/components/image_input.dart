// // ignore_for_file: unnecessary_null_comparison

// import 'dart:io';

// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as syspaths;
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ImageInput extends StatefulWidget {
//   final Function onSelectImage;
//   const ImageInput(this.onSelectImage, {super.key});

//   @override
//   State<ImageInput> createState() => _ImageInputState();
// }

// class _ImageInputState extends State<ImageInput> {
//   File? _storedImage;

//   _takePicture() async {
//     // ignore: no_leading_underscores_for_local_identifiers
//     final ImagePicker _picker = ImagePicker();
//     XFile imageFile = await _picker.pickImage(
//       source: ImageSource.camera,
//       maxWidth: 600,
//     ) as XFile;

//     setState(() {
//       _storedImage = File(imageFile.path);
//     });

//     final appDir = await syspaths.getApplicationDocumentsDirectory();
//     String fileName = path.basename(_storedImage!.path);
//     final savedImage = await _storedImage!.copy('${appDir.path}/$fileName');

//     widget.onSelectImage(savedImage);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Container(
//           width: 180,
//           height: 100,
//           decoration: BoxDecoration(
//             border: Border.all(
//               width: 1,
//               color: Colors.grey,
//             ),
//           ),
//           alignment: Alignment.center,
//           child: _storedImage != null
//               ? Image.file(
//                   _storedImage!,
//                   width: double.infinity,
//                   fit: BoxFit.cover,
//                 )
//               : const Text('Nenhum imagem!'),
//         ),
//         const SizedBox(width: 10),
//         TextButton.icon(
//           onPressed: _takePicture,
//           icon: const Icon(Icons.camera),
//           label: const Text('Tirar Foto'),
//           style: TextButton.styleFrom(
//             foregroundColor: Theme.of(context).colorScheme.primary,
//           ),
//         ),
//       ],
//     );
//   }
// }
