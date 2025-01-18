import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyProfilePic extends StatefulWidget {
  const MyProfilePic({super.key});

  @override
  State<MyProfilePic> createState() => _MyProfilePicState();
}

class _MyProfilePicState extends State<MyProfilePic> {
  String? imageUrl; // To store the fetched image URL

  @override
  void initState() {
    super.initState();
    _fetchProfileImageUrl(); // Fetch the image URL on widget initialization
  }

  Future<void> _fetchProfileImageUrl() async {
    try {
      // Get the current user's UID
      final String uid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch the user document from Firestore
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users') // Replace 'users' with your collection name
          .doc(uid)
          .get();

      // Extract the profile image URL
      setState(() {
        imageUrl = userDoc['profile'];
      });
    } catch (e) {
      // Handle errors (e.g., document not found, no internet)
      print("Error fetching profile image: $e");
      setState(() {
        imageUrl = null; // Fallback in case of error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 25,
      backgroundColor: Colors.grey[200], // Placeholder background color
      backgroundImage: imageUrl != null
          ? CachedNetworkImageProvider(imageUrl!) // Cached image provider
          : null,
      child: imageUrl == null
          ? Icon(
        Icons.person, // Placeholder icon
        size: 50,
        color: Colors.grey,
      )
          : null,
    );
  }
}
