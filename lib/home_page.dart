import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ride_mate/find_ride_page.dart';
import 'package:ride_mate/globals.dart';
import 'package:ride_mate/my_posts.dart';
import 'package:ride_mate/my_rides.dart';
import 'package:ride_mate/post_ride_page.dart';
import 'package:ride_mate/traveler_details.dart';
import 'package:ride_mate/widgets/app_drawer.dart';

class MyHome extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userPhone;

  final RideSearchDetails? rideDetails;

  const MyHome({
    super.key,
    required this.userName,
    required this.userPhone,
    required this.userEmail,
    this.rideDetails, 
  });

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
  int _selectedIndex = 0;

  // Move _buildRideOption above build method
  Widget _buildRideOption({
    required String title,
    required String subtitle,
    required String imageUrl,
    required String buttonText,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title, 
                        style: const TextStyle(
                          fontSize: 24, 
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        subtitle, 
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    child: Image.network(
                      imageUrl, 
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.directions_car, 
                          size: 80, 
                          color: Colors.orange,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                elevation: 3,
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 18),
                minimumSize: const Size(double.infinity, 56),
              ),
              child: Text(
                buttonText, 
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    RideSearchDetails rideData = widget.rideDetails ??
        RideSearchDetails(
          from: "Coimbator",
          to: "Munnar",
          date: DateTime.now(),
          time: const TimeOfDay(hour: 10, minute: 0),
          genderPref: "Any",
          maxFare: 500,
          seats: 1,
          verifiedOnly: false,
        );

    return PopScope(
      canPop: false, // Prevent automatic pop
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        // Show confirmation dialog when back button is pressed
        final bool shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Do you want to exit the app?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Exit'),
              ),
            ],
          ),
        ) ?? false;
        
        if (shouldExit) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
      backgroundColor: Colors.white,
      drawer: AppDrawer(
        userName: widget.userName,
        userEmail: widget.userEmail,
        userPhone: widget.userPhone,
      ),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text(
          'Ride Mate',
          style: TextStyle(
            fontSize: 30,
            color: Color(0xFFA34820),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          const SizedBox(width: 16),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TravelerDetails(
                    userName: widget.userName,
                    rideDetails: rideData,
                  ),
                ),
              );
            },
            icon: const Icon(FontAwesomeIcons.bell, size: 27),
          ),
          const SizedBox(width: 16),
        ],
        backgroundColor: Colors.orange,
      ),

body: Builder(
  builder: (context) {
    if (_selectedIndex == 0) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12.0),
              child: Text(
                'What are you\nLooking for?',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _buildRideOption(
                title: "Offer A Ride",
                subtitle: "I need to fill empty seats",
                imageUrl:
                    "https://www.shutterstock.com/image-vector/happy-couple-young-people-rides-600nw-1619620189.jpg",
                buttonText: "Offer A Ride",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PostRidePage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildRideOption(
                title: "Find A Ride",
                subtitle: "I need a ride",
                imageUrl:
                    "https://png.pngtree.com/png-vector/20221129/ourmid/pngtree-illustration-of-a-vector-icon-for-a-ridesharing-app-or-taxi-cab-app-vector-png-image_42258176.jpg",
                buttonText: "Need A Ride",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const FindRidePage()),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    } else if (_selectedIndex == 1) {
      return  MyPosts();
    } else {
      return MyRides(list: request_list);
    }
  },
),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add),
            label: 'My Posts',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'My Rides'),
        ],
      ),
      ), // Close Scaffold
    ); // Close PopScope
  }
}

