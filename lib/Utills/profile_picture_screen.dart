import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'dart:io';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _image;
  final ImagePicker picker = ImagePicker();

  Future<void> _pickImageFromGallery() async{
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if(pickedFile!= null){
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _pickImageFromCamera() async{
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if(pickedFile!= null){
      setState(() {
        _image = File(pickedFile.path);
      });
    }
}
  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    await Permission.camera.request();
    await Permission.photos.request();
    await Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(color: Colors.teal,),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:  Column(
        children: [
         CircleAvatar(
        radius: 80,
        backgroundImage: _image != null ? FileImage(_image!) : NetworkImage(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_y7FUcigfm_Q8bhbNnrBqqOd4v3C8V6_JtA&s") as ImageProvider,
      ),
      const SizedBox(height: 20,),
      const Text(
        "Don't wear sunglasses, look straight ahead and make sure you're alone.",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 26,
          color: Colors.teal,
          fontWeight: FontWeight.w500,
        ),
      ),
          Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlue,
                minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
            ),
              onPressed: () async{
              await requestPermissions();
                    _pickImageFromCamera();
              },
              child:Text("Take a picture",style: TextStyle(fontSize: 18,color: Colors.white),)
          ),
          const SizedBox(height: 10),
          TextButton(
              onPressed: ()async{
                await requestPermissions();
                  _pickImageFromGallery();
              },
              child: const Text(
                  "Choose a picture",
                    style: TextStyle(
                    fontSize: 16,
                    color: Colors.lightBlue,
                          ),
              )
          )
        ],
      ),
    );
  }
}
