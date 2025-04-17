import 'package:flutter/material.dart';

class ProfileDetailScreen extends StatefulWidget {
  const ProfileDetailScreen({super.key});

  @override
  State<ProfileDetailScreen> createState() => _ProfileDetailScreenState();
}

class _ProfileDetailScreenState extends State<ProfileDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       leading: BackButton(color: Colors.teal,),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  child: Icon(
                    Icons.person,
                    size: 70,
                  ),
                  radius: 40,
                  backgroundColor: Colors.grey,
                ),
                SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "jan",
                      style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    Text(
                      "23 y/o",
                      style: TextStyle(fontSize: 15),
                    ),


                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Experience level: Newcomer", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            Divider(
              thickness: 10,
            ),
            const SizedBox(height: 20),
            const Text("About Jan", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,)),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.chat_bubble_outline_outlined),
                SizedBox(width: 8,),
                Expanded(
                    child: Text("I'm chatty when I feel comfortable", style: TextStyle(color: Colors.grey)),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Divider(
              thickness: 10,
            ),
            const SizedBox(height: 20),
            const Text("No published and completed rides", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 20),
            const Text("Member since April 2025", style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
