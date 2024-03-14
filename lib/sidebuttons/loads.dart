import 'dart:async';
import 'package:flutter/material.dart';

class LoadsScreen extends StatefulWidget {
  @override
  State<LoadsScreen> createState() => _LoadsScreenState();
}

class _LoadsScreenState extends State<LoadsScreen> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _startSlider();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _startSlider() {
    // Automatic sliding every 3 seconds
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (_currentIndex < 2) {
        _currentIndex++;
      } else {
        _currentIndex = 0;
      }
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.fire_truck_sharp,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Move Anything, Anytime, Anywhere....",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),

                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: 3,
                      onPageChanged: (index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            'assets/images/image$index.jpg',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                          (index) =>
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            width: _currentIndex == index ? 25.0 : 15.0,
                            height: 6.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(5),
                              color: _currentIndex == index
                                  ? Colors.orange.shade500
                                  : Colors.grey,
                            ),
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Manage Orders",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Divider(
                    thickness: 3,
                    indent: 10,
                    endIndent: 10,
                    color: Colors.yellowAccent,
                  ),
                  SizedBox(height: 15),
                  _buildButtonsColumn(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsColumn(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildButtonRow(context, [
          _buildButton(
            context,
            Icons.check_circle_outline,
            Colors.green.shade900,
            "Delivered orders",
            '/delivered_orders',
          ),
          _buildButton(
            context,
            Icons.access_time,
            Colors.blue.shade900,
            "Order's Waiting",
            '/waiting_orders',
          ),
        ]),
        SizedBox(height: 15),
        _buildButtonRow(context, [
          _buildButton(
            context,
            Icons.assignment_turned_in_outlined,
            Colors.purple.shade900,
            "Confirmed orders",
            '/confirmed_orders',
          ),
          _buildButton(
            context,
            Icons.cancel_outlined,
            Colors.red.shade900,
            "Cancelled orders",
            '/cancelled_orders',
          ),
        ]),
        SizedBox(height: 15),
        _buildButtonRow(context, [
          _buildButton(
            context,
            Icons.directions_car_outlined,
            Colors.orange.shade900,
            "Driver Confirmation",
            '/driver_waiting',
          ),
          _buildButton(
            context,
            Icons.directions_car_outlined,
            Colors.blue.shade900,
            "Orders On the Way",
            '/Orders_OntheWay',
          ),
        ]),
      ],
    );
  }

  Widget _buildButtonRow(BuildContext context, List<Widget> buttons) {
    return Row(

      children: buttons.map((button) {
        return Expanded(
          child: button,
        );
      }).toList(),
    );
  }

  Widget _buildButton(BuildContext context, IconData icon, Color color,
      String label, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 15.0,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
            width: 4.0,
          ),
        ),
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: color,
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}