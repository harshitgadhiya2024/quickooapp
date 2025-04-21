import 'package:flutter/material.dart';
import 'package:quickoo/Utills/photos_screen.dart';

class VehicleDetailScreen extends StatefulWidget {
  const VehicleDetailScreen({super.key});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Colors.black,),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Vehicle Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (e) => PhotosScreen()));
              },
              child: Row(
                children: [
                  Text("Add Vehicle Photo",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black),),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Divider(),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (e) => PhotosScreen()));
              },
              child: Row(
                children: [
                  Text("Add Vehicle Name ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black),),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Divider(),
            SizedBox(height: 10,),
            InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (e) => PhotosScreen()));
              },
              child: Row(
                children: [
                  Text("Add Milestone",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black),),
                  Spacer(),
                  Icon(Icons.arrow_forward_ios_rounded,size: 18,),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Divider(),
            SizedBox(height: 10,),
            Spacer(),
            ElevatedButton(
              onPressed: (){

              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],

        ),
      ),
    );
  }
}
