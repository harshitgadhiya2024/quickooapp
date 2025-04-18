import 'package:flutter/material.dart';
import 'package:quickoo/Utills/photos_screen.dart';
import 'package:quickoo/Utills/vehicle_detail_screen.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {

 
  
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
            Text("Add Vehicle",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),),
            SizedBox(height: 20,),
           InkWell(
             onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (e) => PhotosScreen()));
             },
             child: Row(
               children: [
                 Text("Add Driving Licence",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black),),
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
                  Text("Add RC Book",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black),),
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
                Navigator.push(context, MaterialPageRoute(builder: (e) => VehicleDetailScreen()));
              },
              child: Row(
                children: [
                  Text("Add Vehicle Details",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,color: Colors.black),),
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
              onPressed: (){},
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                "Start Verification",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ],

        ),
      ),
    );
  }
}
