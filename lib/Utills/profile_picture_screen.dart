import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:quickoo/Controller/user_data_controller.dart';
import 'package:quickoo/Utills/profile_screen.dart';
import '../Controller/photo_controller.dart';

class ProfilePictureScreen extends StatefulWidget {
  const ProfilePictureScreen({super.key});

  @override
  State<ProfilePictureScreen> createState() => _ProfilePictureScreenState();
}

class _ProfilePictureScreenState extends State<ProfilePictureScreen> {
  File? _image;
  final ImagePicker picker = ImagePicker();
  final ProfileController profileController = Get.put(ProfileController());
  final UserDataController userDataController = Get.put(UserDataController());

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

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      profileController.uploadProfilePhoto(imageFile);
      setState(() => _image = imageFile);
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);
      profileController.uploadProfilePhoto(imageFile);
      setState(() => _image = imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
            onTap: () async{
              Navigator.push(context, MaterialPageRoute(builder: (e) => ProfileScreen()));

              await userDataController.fetchUserData();
            },

            child: Icon(Icons.arrow_back,color: Colors.black,)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Obx(() {
            final imageUrl = profileController.uploadedImageUrl.value;
            final hasLocalImage = _image != null;

            return CircleAvatar(
              radius: 80,
              backgroundImage: hasLocalImage
                  ? FileImage(_image!)
                  : (imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : const NetworkImage(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR_y7FUcigfm_Q8bhbNnrBqqOd4v3C8V6_JtA&s")) as ImageProvider,
            );
          }),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Don't wear sunglasses, look straight ahead and make sure you're alone.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {
                await requestPermissions();
                _pickImageFromCamera();
              },
              child: const Text(
                "Take a picture",
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await requestPermissions();
              _pickImageFromGallery();
            },
            child: const Text(
              "Choose a picture",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
