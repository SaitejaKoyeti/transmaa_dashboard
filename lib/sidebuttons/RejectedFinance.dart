import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RejectedFinance extends StatelessWidget {
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
              .collection('Finance')
              .where('status', isEqualTo: 'Not Interested')
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
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
                  "Rejected Detail's",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 25,
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: (snapshot.data!.docs.length + 1) ~/ 2,
                    itemBuilder: (context, index) {
                      int firstIndex = index * 2;
                      int secondIndex = index * 2 + 1;
                      return Row(
                        children: [
                          Expanded(
                            child: firstIndex < snapshot.data!.docs.length ? CardWidget(document: snapshot.data!.docs[firstIndex]) : SizedBox(),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: secondIndex < snapshot.data!.docs.length ? CardWidget(document: snapshot.data!.docs[secondIndex]) : SizedBox(),
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

class CardWidget extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> document;

  const CardWidget({Key? key, required this.document}) : super(key: key);

  @override
  _CardWidgetState createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> driver = widget.document.data();
    String documentId = widget.document.id; // Get the document ID
    String name = driver['name'];
    String status = driver['status'];
    String phoneNumber = driver['phoneNumber'] ?? ''; // Use empty string if null
    String rcNumber = driver['rcNumber'] ?? ''; // Use empty string if null
    String vehicleType = driver['vehicleType'] ?? ''; // Use empty string if null

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: Card(
        color: isHovering ? Colors.black.withOpacity(0.6) : Colors.black.withOpacity(0.1),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        elevation: isHovering ? 10 : 5,
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: $name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.yellowAccent)),
              Text('Status: $status', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              Text('Phone: $phoneNumber', style: TextStyle(fontSize: 16, color: Colors.white)),
              Text('RC Number: $rcNumber', style: TextStyle(fontSize: 16, color: Colors.white)),
              Text('Vehicle Type: $vehicleType', style: TextStyle(fontSize: 16, color: Colors.white)),
              SizedBox(height: 8),
              Divider(color: Colors.blue),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _deleteDocument(documentId);
                    },
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent.withOpacity(0.4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteDocument(String documentId) {
    FirebaseFirestore.instance.collection('Finance').doc(documentId).delete().then((value) {
      // Document deleted successfully
    }).catchError((error) {
      // Handle error
    });
  }
}
