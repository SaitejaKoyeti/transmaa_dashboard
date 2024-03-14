import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Finance_interested.dart';
import 'RejectedFinance.dart';


class FinanceScreen extends StatefulWidget {
  @override
  _FinanceScreenState createState() => _FinanceScreenState();
}

class _FinanceScreenState extends State<FinanceScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        centerTitle: true,
        backgroundColor: Colors.black.withOpacity(0.5),
        title: Text('Finance',
          style: TextStyle(color: Colors.white),),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Interestedfinance()),
              );
            },
            child: Text(
              "Interested",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.withOpacity(0.8),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RejectedFinance()),
              );
            },
            child: Text(
              "Not Interested",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withOpacity(0.8),
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance.collection('Finance').snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            // Filter out documents with status 'Interested' or 'Not Interested'
            final filteredDocs = snapshot.data!.docs.where((doc) =>
            doc.data()['status'] != 'Interested' &&
                doc.data()['status'] != 'Not Interested'
            ).toList();

            // Create a list of rows, each containing two list tiles
            List<Widget> rows = [];
            for (int index = 0; index < filteredDocs.length; index += 2) {
              // Ensure that the second tile exists before adding a row
              if (index + 1 < filteredDocs.length) {
                rows.add(
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(context, filteredDocs[index].data(),
                            filteredDocs[index].id),
                      ),
                      SizedBox(width: 8.0),
                      Expanded(
                        child: _buildCard(
                            context, filteredDocs[index + 1].data(),
                            filteredDocs[index + 1].id),
                      ),
                    ],
                  ),
                );
              } else {
                // Add the last tile if there is only one left
                rows.add(
                  Row(
                    children: [
                      Expanded(
                        child: _buildCard(context, filteredDocs[index].data(),
                            filteredDocs[index].id),
                      ),
                    ],
                  ),
                );
              }
            }

            // Return a ListView to display the rows
            return ListView(
              children: rows,
            );
          }
        },
      ),
    );
  }

  Widget _buildCard(BuildContext context, Map<String, dynamic> data,
      String documentId) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animationController.value,
          child: Card(
            color: Colors.black.withOpacity(0.5),
            margin: EdgeInsets.all(8.0),
            elevation: 4.0,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Name: ${data['name']}',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.yellowAccent,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'Phone Number: ${data['phoneNumber']}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'RC Number: ${data['rcNumber']}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Vehicle Type: ${data['vehicleType']}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 170,),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          _updateStatus(documentId, 'Interested');
                        },
                        icon: Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 10,),
                      IconButton(
                        onPressed: () {
                          _updateStatus(documentId, 'Not Interested');
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  void _updateStatus(String documentId, String status) {
    FirebaseFirestore.instance.collection('Finance').doc(documentId).update({
      'status': status,
    }).then((value) {
      // Successfully updated
    }).catchError((error) {
      // Handle error
    });
  }
}
