import 'package:flutter/material.dart';
import 'Sellscreen.dart';
import 'buyscreen.dart';
import 'intrested.dart'; // Import your next screen file here

class BuynSellScreen extends StatefulWidget {
  @override
  _BuynSellScreenState createState() => _BuynSellScreenState();
}

class _BuynSellScreenState extends State<BuynSellScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animationController.forward(); // Start the animation
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
            title: Text(
              'Buy & Sell',
              style: TextStyle(color: Colors.white),
            ),

            backgroundColor: Colors.black.withOpacity(0.5)
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image

            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  _buildImageWithNavigation(
                    context,
                    'assets/images/Buy.jpg',
                    200,
                    BuyScreen(),
                  ),
                  _buildImageWithNavigation(
                    context,
                    'assets/images/Sell.jpg',
                    200,
                    SellingScreen(),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          margin: EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InterestedScreen()),
              );
            },
            child: Text('Interested',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16
              ),
            ),
          ),
        )
    );
  }

  Widget _buildImageWithNavigation(BuildContext context, String imagePath,
      double size, Widget screen) {
    return SizeTransition(
      sizeFactor: CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
      child: GestureDetector(
        onTap: () {
          // Navigate to the corresponding screen when image is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // Adjust the border radius as needed
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 3,
                blurRadius: 7,
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            // Match the border radius of the container
            child: Image.asset(
              imagePath,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),

    );
  }
}
