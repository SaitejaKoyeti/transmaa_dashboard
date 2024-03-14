import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ordersdelivered extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backimage.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('DriversAcceptedOrders')
              .where('status', isEqualTo: "Delivered")
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No data available'));
            }
            return Column(
              children: [
                Text(
                  'Delivered Orders',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: (snapshot.data!.docs.length / 2).ceil(),
                    itemBuilder: (context, index) {
                      var startIndex = index * 2;
                      var endIndex = (index + 1) * 2;
                      if (endIndex > snapshot.data!.docs.length) {
                        endIndex = snapshot.data!.docs.length;
                      }

                      return Row(
                        children: [
                          for (var i = startIndex; i < endIndex; i++)
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white60),
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10), // Set border radius here
                                ),
                                child: ListTile(
                                  title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Customer Name: ${snapshot.data!.docs[i]['customerName'] ?? 'N/A'}',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow),
                                      ),
                                      Builder(
                                        builder: (context) {
                                          try {
                                            return Text(
                                              'Customer Phone Number: ${snapshot.data!.docs[i]['customerphoneNumber']}',
                                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                            );
                                          } catch (e) {
                                            print('Error accessing customerphoneNumber: $e');
                                            return Text('Customer Phone Number: N/A', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white));
                                          }
                                        },
                                      ),
                                      Text(
                                        'Driver Name: ${snapshot.data!.docs[i]['driverName'] ?? 'N/A'}',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellow),
                                      ),
                                      Text(
                                        'Driver Phone Number: ${snapshot.data!.docs[i]['driverPhoneNumber'] ?? 'N/A'}',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Text(
                                        'Status: ${snapshot.data!.docs[i]['status'] ?? 'N/A'}',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                      Text('Goods Type: ${snapshot.data!.docs[i]['selectedGoodsType'] ?? 'N/A'}', style: TextStyle(color: Colors.white,fontSize: 15),),
                                      Text('Date: ${snapshot.data!.docs[i]['selectedDate']?.toDate()?.toLocal() ?? 'N/A'}', style: TextStyle(color: Colors.white,fontSize: 15)),
                                      Text('Time: ${snapshot.data!.docs[i]['selectedTime'] ?? 'N/A'}', style: TextStyle(color: Colors.white,fontSize: 15)),
                                      Text('From: ${snapshot.data!.docs[i]['fromLocation'] ?? 'N/A'}', style: TextStyle(color: Colors.white,fontSize: 15)),
                                      Text('To: ${snapshot.data!.docs[i]['toLocation'] ?? 'N/A'}', style: TextStyle(color: Colors.white,fontSize: 15)),
                                      SizedBox(height: 2),
                                      Text(
                                        'Truck Details:',
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.yellowAccent),
                                      ),
                                      Text('Truck Name: ${snapshot.data!.docs[i]['selectedTruck']['name'] ?? 'N/A'}', style: TextStyle(color: Colors.white,fontSize: 15)),
                                      Text('Truck Price: ${snapshot.data!.docs[i]['selectedTruck']['price'] ?? 'N/A'}', style: TextStyle(color: Colors.white,fontSize: 15)),
                                      Text('Truck Weight Capacity: ${snapshot.data!.docs[i]['selectedTruck']['weightCapacity'] ?? 'N/A'}', style: TextStyle(color: Colors.white,fontSize: 15)),
                                      SizedBox(height: 8),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
