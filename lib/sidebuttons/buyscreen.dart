import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class BuyScreen extends StatefulWidget {
  @override
  _BuyScreenState createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController vehicleModelController = TextEditingController();
  final TextEditingController yearsOfVehicleController = TextEditingController();

  bool showTextFields = true;
  Color sellButtonColor = Colors.orangeAccent;
  Color byeButtonColor = Colors.orangeAccent;

  List<Uint8List?> _images = List.filled(4, null);
  Color saveButtonColor = Colors.red;

  Future<String> saveUserDataToFirestore() async {
    final CollectionReference users = FirebaseFirestore.instance.collection('Buycollection');

    List<String> imageUrls = await uploadImagesToStorage();

    await users.add({
      'Company': nameController.text,
      'Year': yearsOfVehicleController.text,
      'Vehicle Model': vehicleModelController.text,
      'ImageURLs': imageUrls,
    });

    return imageUrls.join(", ");
  }

  Future<List<String>> uploadImagesToStorage() async {
    List<String> imageUrls = [];
    for (int i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage
            .ref()
            .child('images')
            .child('image_${DateTime.now().millisecondsSinceEpoch}_$i.png');

        await ref.putData(_images[i]!);

        String downloadURL = await ref.getDownloadURL();
        imageUrls.add(downloadURL);
      }
    }
    return imageUrls;
  }

  void disableImageSelection(int index) {
    setState(() {
      _images[index] = Uint8List(0);
    });
  }

  bool areFieldsValid() {
    return nameController.text.isNotEmpty &&
        vehicleModelController.text.isNotEmpty &&
        yearsOfVehicleController.text.isNotEmpty &&
        _images.any((image) => image != null);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        Image.asset(
          'assets/images/backimage.jpg', // Provide the path to your background image
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Set the scaffold background to transparent
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 250,
                      width: 300,
                    ),
                  ),
                  SizedBox(height: 10,),
                  if (showTextFields) ...[
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Company',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: vehicleModelController,
                      decoration: InputDecoration(
                        labelText: 'Model',labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: yearsOfVehicleController,
                      decoration: InputDecoration(
                        labelText: 'Year',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      ),
                    ),

                    SizedBox(height: 10),
                    Row(
                      children: [
                        Padding(padding: EdgeInsets.only(left: 10)),
                        Text('Upload Images', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                    buildImagePick(),
                  ],
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      if (areFieldsValid()) {
                        await saveUserDataToFirestore();
                        setState(() {
                          saveButtonColor = Colors.green;
                        });

                        // Reset text controllers
                        nameController.clear();
                        vehicleModelController.clear();
                        yearsOfVehicleController.clear();

                        // Clear image list
                        setState(() {
                          _images = List.filled(4, null);
                        });

                        // Optionally, you can show a confirmation message after successful save.
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Data saved successfully'),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        setState(() {
                          saveButtonColor = Colors.green;
                        });
                        // Show a snackbar or any other indication for invalid fields
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Please fill in all fields and upload the image.'),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return saveButtonColor.withOpacity(0.5);
                        }
                        return saveButtonColor;
                      }),
                    ),
                    child: Text('Save Data',style: TextStyle(
                        color: Colors.white
                    ),),
                  ),
                  StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('Buycollection').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      return Column(
                        children: snapshot.data!.docs.map((DocumentSnapshot document) {
                          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                          String imageURL = data['ImageURLs'][0]; // Assuming you store the image URL in an array
                          return Card(
                            margin: EdgeInsets.all(10),
                            child: ListTile(
                              leading: Image.network(imageURL), // Display the image as the leading widget
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Company: ${data['Company']}',
                                    style: TextStyle(
                                      fontSize: 16, // Adjust font size as needed
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Model: ${data['Vehicle Model']}',
                                    style: TextStyle(
                                      fontSize: 14, // Adjust font size as needed
                                    ),
                                  ),
                                  Text(
                                    'Year: ${data['Year']}',
                                    style: TextStyle(
                                      fontSize: 14, // Adjust font size as needed
                                    ),
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  await FirebaseFirestore.instance.collection('Buycollection').doc(document.id).delete();
                                },
                              ),
                            ),


                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildImagePick() {
    return Row(
      children: List.generate(1, (index) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ImagePick(
              onImagePicked: (Uint8List? image) {
                setState(() {
                  _images[index] = image;
                });
              },
              width: 140,
              height: 140,
            ),
          ),
        );
      }),
    );
  }
}

class ImagePick extends StatefulWidget {
  final Function(Uint8List?) onImagePicked;
  final double width;
  final double height;

  ImagePick({
    required this.onImagePicked,
    required this.width,
    required this.height,
  });

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  Uint8List? _image;

  void selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery);
    if (img != null) {
      setState(() {
        _image = img;
      });
      widget.onImagePicked(_image);
    }
  }

  Future<Uint8List?> pickImage(ImageSource source) async {
    final ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file != null) {
      return await file.readAsBytes();
    }
    print('No Images Selected');
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Text(
                  'Front side',
                  style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 5,),
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: _image != null
                        ? Image.memory(
                      _image!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                        : Container(),
                  ),
                  Positioned(
                    child: IconButton(
                      onPressed: selectImage,
                      icon: Icon(Icons.add_a_photo),
                    ),
                    bottom: 30,
                    left: 30,
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
