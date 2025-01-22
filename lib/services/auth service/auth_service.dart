import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  //instance of Auth and firestore
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final String? cloudinaryApiKey = "746222329139784";
  final String? cloudinaryApiSecret = "uLrnd6eyX2C6iOeSfQdtuXx_F8w";
  final String? cloudinaryCloudName = "di22keonp";
  //get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //signin
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print(e.toString());
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signout() async {
    return await _auth.signOut();
  }

  // to reset password of account
  void resetPassword(email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );
      log("Reset link sent");
    } catch (e) {
      log(e.toString());
    }
  }

  // get username
  Future<String> getName() async {
    var user = getCurrentUser();
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }
    var collection = _firestore.collection("Users");
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await collection.doc(user.uid).get();
    Map<String, dynamic>? data = docSnapshot.data();
    if (data == null) {
      throw Exception("User data not found.");
    }
    String name = data['name'].toString();
    // log(name);
    return name;
  }
  Future<String> getProfile() async {
    var user = getCurrentUser();
    if (user == null) {
      throw Exception("No user is currently signed in.");
    }
    var collection = _firestore.collection("Users");
    DocumentSnapshot<Map<String, dynamic>> docSnapshot = await collection.doc(user.uid).get();
    Map<String, dynamic>? data = docSnapshot.data();
    if (data == null) {
      throw Exception("User data not found.");
    }
    String name = data['profile'].toString();
    // log(name);
    return name;
  }

  Future<String> uploadProfileToCloudinary(File file) async{
    try {
      final Uri uri = Uri.parse(
          "https://api.cloudinary.com/v1_1/$cloudinaryCloudName/upload");

      final request = http.MultipartRequest('POST', uri)
        ..fields['upload_preset'] = 'akshat'
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonResponse = json.decode(responseBody);
        return jsonResponse['secure_url'] as String;
      } else {
        log('Cloudinary upload failed: ${response.statusCode}');
        return '';
      }
    } catch (e) {
      log('Error uploading to Cloudinary: $e');
      return '';
    }
  }

  //change username
  Future<void> changeUsername(String newName) async{
    try{
      _firestore.collection("Users")
          .doc(getCurrentUser()!.uid)
          .update({'name':newName});
    }catch(e){
      throw Exception(e.toString());
    }
  }

  //signup with email and password
  Future<UserCredential> signupWithEmailPAssword(String fullName, email, password,File profile_path) async {
    try {
      String profile = await uploadProfileToCloudinary(profile_path);
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      _firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .set({'uid': userCredential.user!.uid, 'email': email , 'name' : fullName, 'profile': profile});
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }
}
