import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DriversAcceptedOrders extends StatelessWidget {
  Future<void> sendTwilioSMS(String toPhoneNumber, String message) async {
    // Replace these with your Twilio credentials
    final accountSid = 'AC8032394725a51f80a26427f0ecd06af6';
    final authToken = 'f9b098e24ae5cbeeeede74f04ed4ac67';
    final twilioNumber = '+16562205940';

    final response = await http.post(
      Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json'),
      headers: {
        'Authorization': 'Basic ' + base64Encode(utf8.encode('$accountSid:$authToken')),
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'To': toPhoneNumber,
        'From': twilioNumber,
        'Body': message,
      },
    );

    if (response.statusCode == 201) {
      print('SMS sent successfully');
    } else {
      print('Failed to send SMS: ${response.body}');
    }
  }

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
          stream: FirebaseFirestore.instance.collection('DriversAcceptedOrders')
              .where('status', isEqualTo: "Accepted")
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
                  "Driver's Accepted Order's",
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 20,
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
                      int? selectedTruckPrice = int.tryParse(selectedTruckData['price'].toString());
                      int? selectedTruckWeightCapacity = int.tryParse(selectedTruckData['weightCapacity'].toString());

                      // Fetching name and phone number
                      String customerName = order['customerName'] ?? ''; // Adjust field name if different in Firestore
                      String customerPhoneNumber = order['customerPhoneNumber'] ?? ''; // Adjust field name if different in Firestore
                      String status = order['status'] ?? 'Pending';
                      String driverName = order['driverName'] ?? ''; // Adjust field name if different in Firestore
                      String driverPhoneNumber = order['driverPhoneNumber'] ?? ''; // Adjust field name if different in Firestore

                      return Card(
                        color: Colors.black.withOpacity(0.5),
                        margin: EdgeInsets.all(10),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Customer Name: $customerName', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellowAccent)),
                                    Text('Customer Phone Number: $customerPhoneNumber', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                    SizedBox(height: 2),
                                    Text('Driver Name: $driverName', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellowAccent)),
                                    Text('Driver Phone Number: $driverPhoneNumber', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                    Text('Status: $status', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white)),
                                    SizedBox(height: 4),
                                    Text('Goods Type: $selectedGoodsType',style: TextStyle(color: Colors.white)),
                                    Text('Date: ${selectedDate.toLocal()}',style: TextStyle(color: Colors.white)),
                                    Text('Time: $selectedTime',style: TextStyle(color: Colors.white)),
                                    Text('From: $fromLocation',style: TextStyle(color: Colors.white)),
                                    Text('To: $toLocation',style: TextStyle(color: Colors.white)),
                                    SizedBox(height: 8),
                                    Text('Truck Details:', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.yellowAccent)),
                                    Text('Truck Name: $selectedTruckName',style: TextStyle(color: Colors.white)),
                                    Text('Truck Price: ${selectedTruckPrice.toString()}',style: TextStyle(color: Colors.white)),
                                    Text('Truck Weight Capacity: ${selectedTruckWeightCapacity.toString()}',style: TextStyle(color: Colors.white)),
                                    SizedBox(height: 8),
                                  ],
                                ),
                              ),
                              // Add Send Message button
                              ElevatedButton(
                                onPressed: () async {
                                  if (status != "Order's to be delivered") {
                                    String driverMessage = 'Hi $driverName, Your order is confirmed. From: $fromLocation To: $toLocation Date: ${selectedDate.toLocal()}. For more information, please contact Transmaa.';
                                    String customerMessage = 'Hi $customerName, Your order is confirmed. From: $fromLocation To: $toLocation Date: ${selectedDate.toLocal()}. Your driver is $driverName. For more information, please contact Transmaa.';
                                    await sendTwilioSMS(customerPhoneNumber, customerMessage);
                                    await sendTwilioSMS(driverPhoneNumber, driverMessage);

                                    FirebaseFirestore.instance.collection('DriversAcceptedOrders').doc(orderData.id).update({
                                      'status': "Order's to be delivered"  // Corrected status value
                                    }).then((_) {
                                      print('Order status updated successfully.');
                                    }).catchError((error) {
                                      print('Failed to update order status: $error');
                                    });
                                  } else {
                                    print('Status already updated.');
                                  }
                                },
                                child: Text('Send Message'),
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
