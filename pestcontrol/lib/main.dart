import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corn Disease Detector',
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const ImagePickerScreen(),
    );
  }
}

class ImagePickerScreen extends StatefulWidget {
  const ImagePickerScreen({Key? key}) : super(key: key);

  @override
  State<ImagePickerScreen> createState() => _ImagePickerScreenState();
}

class _ImagePickerScreenState extends State<ImagePickerScreen> {
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);

      if (pickedFile == null) return;

      setState(() {
        _imageFile = File(pickedFile.path);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Show info dialog with usage instructions
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How to Use'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: const [
                Text('📸 Corn Disease Detection App Instructions:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text(
                    '1. Use "Select Image" to choose a photo from your gallery'),
                SizedBox(height: 5),
                Text('2. Use "Camera" to take a new photo of corn leaves'),
                SizedBox(height: 5),
                Text('3. The image will appear in the preview area'),
                SizedBox(height: 5),
                Text(
                    '4. Make sure the corn leaf is clearly visible and well-lit'),
                SizedBox(height: 10),
                Text('Tips:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('• Close-up images work best for disease detection'),
                Text('• Avoid shadows and glare on the leaf surface'),
                Text(
                    '• Include multiple leaves if they show different symptoms'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Got it'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Corn Disease Detector'),
        actions: [
          // Information icon in app bar
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'How to use',
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Image Preview Area
          Expanded(
            child: Center(
              child: _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      fit: BoxFit.contain,
                    )
                  : const Text(
                      'Select an image or take a photo',
                      style: TextStyle(fontSize: 18),
                    ),
            ),
          ),

          // Buttons Area
          Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Select Image'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Camera'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(200, 50),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
