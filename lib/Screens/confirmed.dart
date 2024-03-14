import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmedordersScreen extends StatelessWidget {
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
          stream: FirebaseFirestore.instance.collection('Transmaa_accepted_orders').snapshots(),
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
                  "Transma Accepted Order's",
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var orderData = snapshot.data!.docs[index];
                      Map<String, dynamic> order = orderData.data() as Map<String, dynamic>;

                      // Extracting fields
                      String selectedGoodsType = order['selectedGoodsType'] ?? '';
                      String selectedTime = order['selectedTime'] ?? '';
                      String fromLocation = order['fromLocation'] ?? '';
                      String toLocation = order['toLocation'] ?? '';

                      // Handling selectedDate
                      Timestamp selectedDateTimestamp = order['selectedDate'] ?? Timestamp.now();
                      DateTime selectedDate = selectedDateTimestamp.toDate();

                      // Handling selectedTruck
                      Map<String, dynamic> selectedTruckData = order['selectedTruck'] ?? {};
                      String selectedTruckName = selectedTruckData['name'] ?? '';
                      String selectedTruckPrice = order['selectedTruck']['price'].toString() ?? '';
                      String selectedTruckWeightCapacity = order['selectedTruck']['weightCapacity'].toString() ?? '';


                      // Fetching name and phone number
                      String customerName = order['CustomerName'] ?? ''; // Adjust field name if different in Firestore
                      String customerphoneNumber = order['CustomerphoneNumber'] ?? ''; // Adjust field name if different in Firestore

                      return Card(
                        color: Colors.black.withOpacity(0.5),
                        margin: EdgeInsets.all(10),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Customer Name: $customerName',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellowAccent),
                              ),
                              SizedBox(height: 4),
                              Text('Customer Phone Number: $customerphoneNumber',style: TextStyle(
                                  color: Colors.white
                              ),),
                              SizedBox(height: 8),
                              Text('Goods Type: $selectedGoodsType',style: TextStyle(
                                  color: Colors.white
                              ),),
                              Text('Date: ${selectedDate.toLocal()}',style: TextStyle(
                                  color: Colors.white
                              ),),
                              Text('Time: $selectedTime',style: TextStyle(
                                  color: Colors.white
                              ),),
                              Text('From: $fromLocation',style: TextStyle(
                                  color: Colors.white
                              ),),
                              Text('To: $toLocation',style: TextStyle(
                                  color: Colors.white
                              ),),
                              SizedBox(height: 8),
                              Text(
                                'Truck Details:',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellowAccent),
                              ),
                              Text('Truck Name: $selectedTruckName',style: TextStyle(
                                  color: Colors.white
                              ),),
                              Text('Truck Price: ${selectedTruckPrice.toString()}',style: TextStyle(
                                  color: Colors.white
                              ),),
                              Text('Truck Weight Capacity: ${selectedTruckWeightCapacity.toString()}',style: TextStyle(
                                  color: Colors.white
                              ),),


                            ],
                          ),
                        ),
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