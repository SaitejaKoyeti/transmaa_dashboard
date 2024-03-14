import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'cancelled.dart';

class WaitingordersScreen extends StatelessWidget {
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
          stream: FirebaseFirestore.instance.collection('pickup_requests').snapshots(),
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
                  "Order's Waiting",
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
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
                      int selectedTruckPrice = selectedTruckData['price'] ?? 0;
                      String selectedTruckWeightCapacity = selectedTruckData['weightCapacity'] ?? '';

                      // Fetching name and phone number
                      String customerName = order['customerName'] ?? ''; // Adjust field name if different in Firestore
                      String customerphoneNumber = order['customerphoneNumber'] ?? ''; // Adjust field name if different in Firestore

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
                                'CustomerName: $customerName',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellowAccent),
                              ),
                              SizedBox(height: 4),
                              Text('CustomerphoneNumber: $customerphoneNumber',style: TextStyle(color: Colors.white),),
                              SizedBox(height: 8),
                              Text('Goods Type: $selectedGoodsType',style: TextStyle(color: Colors.white),),
                              Text('Date: ${selectedDate.toLocal()}',style: TextStyle(color: Colors.white),),
                              Text('Time: $selectedTime',style: TextStyle(color: Colors.white),),
                              Text('From: $fromLocation',style: TextStyle(color: Colors.white),),
                              Text('To: $toLocation',style: TextStyle(color: Colors.white),),
                              SizedBox(height: 8),
                              Text(
                                'Truck Details:',
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellowAccent),
                              ),
                              Text('Truck Name: $selectedTruckName',style: TextStyle(color: Colors.white),),
                              Text('Truck Price: $selectedTruckPrice',style: TextStyle(color: Colors.white),),
                              Text('Truck Weight Capacity: $selectedTruckWeightCapacity',style: TextStyle(color: Colors.white),),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Handle accept button press
                                      // Store data in a different collection
                                      FirebaseFirestore.instance.collection('Transmaa_accepted_orders').add({
                                        'CustomerName': customerName, // Assuming 'name' is retrieved from Firestore
                                        'CustomerphoneNumber': customerphoneNumber,
                                        'selectedGoodsType': selectedGoodsType,
                                        'selectedDate': selectedDateTimestamp,
                                        'selectedTime': selectedTime,
                                        'selectedTruck': selectedTruckData,
                                        'fromLocation': fromLocation,
                                        'toLocation': toLocation,
                                        // You can add more fields if necessary
                                      });

                                      // Delete the document from pickup_requests collection
                                      orderData.reference.delete();
                                    }, style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, // Change the color here
                                  ),
                                    child: Text('Accept',style:
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),),
                                  ),
                                  SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      // Store rejected data in Firestore
                                      FirebaseFirestore.instance.collection('rejected_orders').add({
                                        'CustomerName': customerName, // Assuming 'name' is retrieved from Firestore
                                        'CustomerphoneNumber': customerphoneNumber, // Assuming 'phoneNumber' is retrieved from Firestore
                                        'selectedGoodsType': selectedGoodsType,
                                        'selectedDate': selectedDateTimestamp,
                                        'selectedTime': selectedTime,
                                        'selectedTruck': selectedTruckData,
                                        'fromLocation': fromLocation,
                                        'toLocation': toLocation,
                                        // You can add more fields if necessary
                                      });


                                      // Delete the document from pickup_requests collection
                                      orderData.reference.delete();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red, // Change the color here
                                    ),
                                    child: Text('Reject',style:
                                    TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 17,
                                    ),),),
                                ],
                              ),
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