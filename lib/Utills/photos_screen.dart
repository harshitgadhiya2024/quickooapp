import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PhotosScreen extends StatefulWidget {
  const PhotosScreen({super.key});

  @override
  State<PhotosScreen> createState() => _PhotosScreenState();
}

class _PhotosScreenState extends State<PhotosScreen> {

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Colors.black,),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:  Padding(
        padding: const EdgeInsets.all(20),
        child: Column(

          children: [
            Text("Driving Licence",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
            SizedBox(height: 20,),
            Container(
              height: 200,
              width: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                image: DecorationImage(

                    image: _image != null ? FileImage(_image!) :
                    NetworkImage("https://staticimg.amarujala.com/assets/images/2024/04/18/daugdhha-sal-ma-bha-naha-bna-daraivaga-lisasa_9e822732a408730338523930183eda1f.jpeg?w=414&dpr=1.0&q=80"),
                )
              ),
            ),
            SizedBox(height: 20,),
            const Text(
              "Don't wear sunglasses, look straight ahead and make sure you're alone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),

            // CircleAvatar(
            //   radius: 80,
            //   backgroundImage: _image != null ? FileImage(_image!) : NetworkImage(
            //       "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_y7FUcigfm_Q8bhbNnrBqqOd4v3C8V6_JtA&s") as ImageProvider,
            // ),
            const SizedBox(height: 20,),

            Spacer(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onPressed: () async{
                    await requestPermissions();
                    _pickImageFromCamera();
                  },
                  child:Text("Take a picture",style: TextStyle(fontSize: 18,color: Colors.white),)
              ),
            ),
            TextButton(
                onPressed: ()async{
                  await requestPermissions();
                  _pickImageFromGallery();
                },
                child: const Text(
                  "Choose a picture",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                )
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

