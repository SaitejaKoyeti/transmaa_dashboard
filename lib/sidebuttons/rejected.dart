import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:transmaa_dashboard/sidebuttons/verification.dart'; // Assuming ImageScreen is defined here

class Rejectedscreens extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backimage.jpg"), // Add your background image path here
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Rejected Drivers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Driver')
                    .where('status', isEqualTo: 'Rejected')
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No data available'));
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot<Map<String, dynamic>> driverData = snapshot.data!.docs[index];
                      Map<String, dynamic> driver = driverData.data();
                      String imageUrl = driver['image'] ?? '';
                      String name = driver['name'] ?? '';
                      String status = driver['status'] ?? '';
                      String phoneNumber = driver['phone_number'] ?? '';

                      return Card(
                        color: Colors.black.withOpacity(0.6),
                        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        elevation: 5,
                        child: Padding(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => ImageScreen(imageUrl)),
                                      );
                                    },
                                    child: Image.network(
                                      imageUrl,
                                      width: 150,
                                      height: 150,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 20,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Name: $name',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.yellowAccent,
                                        ),
                                      ),
                                      Text(
                                        'Status: $status',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: status == 'verified' ? Colors.green : status == 'rejected' ? Colors.red : Colors.yellowAccent,
                                        ),
                                      ),
                                      Text(
                                        'Phone: $phoneNumber',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 15),
                              Divider(color: Colors.grey),
                              SizedBox(height: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: driver.entries.map((entry) {
                                  if (entry.key != 'image' && entry.key != 'name' && entry.key != 'status' && entry.key != 'phone_number') {
                                    return Text(
                                      '${entry.key}: ${entry.value}',
                                      style: TextStyle(fontSize: 16, color: Colors.white),
                                    );
                                  } else {
                                    return SizedBox.shrink();
                                  }
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
