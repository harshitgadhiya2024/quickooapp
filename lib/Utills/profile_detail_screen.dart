import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:quickoo/Controller/user_data_controller.dart';
import 'package:quickoo/Utills/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_color.dart';
import 'edit_dob_screen.dart';
import 'edit_firstname_screen.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {

  final UserDataController userDataController = Get.put(UserDataController());
  String firstName = "Harshit Gadhiya";
  String dob = "17-Nov-2000";


  @override
  void initState() {
    super.initState();
    loadProfileData();

  }

  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('first_name') ?? firstName;
      dob = prefs.getString('dob') ?? dob;
    });
  }

  Future<void> saveFirstName(String name) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('first_name', name);
  }

  Future<void> saveDob(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('dob', value);
  }



  @override
  Widget build(BuildContext context) {
    // Call fetchUser() every time screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      userDataController.fetchUserData();
    });

    final user = userDataController.userModel.value!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: InkWell(
            onTap: () async{
              Navigator.pop(context, true);
              await userDataController.fetchUserData();
              },

            child: Icon(Icons.arrow_back,color: Colors.black,)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        if (userDataController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final user = userDataController.userModel.value!;
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  user.isProfile
                      ? CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(user.profileUrl)
                  )
                      : CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.black,
                      child: (const Icon(Icons.person,color: Colors.white,size: 40,))
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.firstName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                      Text(
                        "NewComer",
                        style: TextStyle(fontSize: 14, color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              const Text(
                "Personal Details",
                style: TextStyle(
                  color: AppColor.bottomcurveColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditFirstNameScreen(firstName: user.firstName),
                    ),
                  );

                },
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Name", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        Text(user.firstName, style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded, color: AppColor.bottomcurveColor),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(thickness: 1),
              const SizedBox(height: 10),
              InkWell(
                onTap: () async {
                 await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EditDobScreen(currentDob: user.dob),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Date Of Birth", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                        Text(dob, style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios_rounded, color: AppColor.bottomcurveColor),
                  ],
                ),
              ),
            ],
          ),
        );
      }),

    );
  }
}
