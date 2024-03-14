import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CancelledOrdersScreen extends StatefulWidget {
  @override
  _CancelledOrdersScreenState createState() => _CancelledOrdersScreenState();
}

class _CancelledOrdersScreenState extends State<CancelledOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/backimage.jpg"),
            // Provide your image path here
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('rejected_orders')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No cancelled orders available'));
            }
            List<Map<String, dynamic>> cancelledOrders =
            snapshot.data!.docs.map((doc) {
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
              return {
                'CustomerName': data['CustomerName'] ?? '',
                'CustomerphoneNumber': data['CustomerphoneNumber'] ?? '',
                'selectedGoodsType': data['selectedGoodsType'] ?? '',
                'selectedDate': (data['selectedDate'] as Timestamp).toDate() ??
                    DateTime.now(),
                'selectedTime': data['selectedTime'] ?? '',
                'selectedTruck': data['selectedTruck'] ?? {},
              };
            }).toList();

            return Column(
              children: [
                Text(
                  'Cancelled Orders',
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontSize: 30,
                      color: Colors.white,
                      fontWeight: FontWeight.w500),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: (cancelledOrders.length / 3).ceil(),
                    itemBuilder: (context, index) {
                      final startIndex = index * 3;
                      final endIndex = startIndex + 3 <= cancelledOrders.length
                          ? startIndex + 3
                          : cancelledOrders.length;
                      final ordersInRow =
                      cancelledOrders.sublist(startIndex, endIndex);

                      return Row(
                        children: ordersInRow.map((order) {
                          return Expanded(
                            child: MagicCard(
                              name: order['CustomerName'] ?? '',
                              phoneNumber: order['CustomerphoneNumber'] ?? '',
                              selectedGoodsType:
                              order['selectedGoodsType'] ?? '',
                              selectedDate:
                              order['selectedDate'] ?? DateTime.now(),
                              selectedTime: order['selectedTime'] ?? '',
                              selectedTruck: order['selectedTruck'] ?? {},
                            ),
                          );
                        }).toList(),
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

class MagicCard extends StatelessWidget {
  final String name;
  final String phoneNumber;
  final String selectedGoodsType;
  final DateTime selectedDate;
  final String selectedTime;
  final Map<String, dynamic> selectedTruck;

  MagicCard({
    required this.name,
    required this.phoneNumber,
    required this.selectedGoodsType,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedTruck,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C0000).withOpacity(0.7),
            Color(0xFA0E0E0E).withOpacity(0.7),
            Color(0xFF090000).withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: $name', style: TextStyle(color: Colors.yellowAccent)),
          Text('Phone Number: $phoneNumber',
              style: TextStyle(color: Colors.yellowAccent)),
          Text('Goods Type: $selectedGoodsType',
              style: TextStyle(color: Colors.white)),
          Text('Date: ${selectedDate.toLocal()}',
              style: TextStyle(color: Colors.white)),
          Text('Time: $selectedTime', style: TextStyle(color: Colors.white)),
          Text('Truck Name: ${selectedTruck['name']}',
              style: TextStyle(color: Colors.white)),
          Text('Truck Price: ${selectedTruck['price']}',
              style: TextStyle(color: Colors.white)),
          Text('Truck Weight Capacity: ${selectedTruck['weightCapacity']}',
              style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
