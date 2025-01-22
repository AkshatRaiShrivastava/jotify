import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final String? cloudinaryApiKey = "746222329139784";
  final String? cloudinaryApiSecret = "uLrnd6eyX2C6iOeSfQdtuXx_F8w";
  final String? cloudinaryCloudName = "di22keonp";

  // fetching all the notes
  Stream<QuerySnapshot> getAllNotes() {
    return _firestore
        .collection('Notes')
        .doc(_auth.currentUser?.uid.toString())
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // delete the note
  Future<void> deleteMessage(String noteId) async {
    try {
      await _firestore
          .collection("Notes")
          .doc(_auth.currentUser?.uid.toString())
          .collection('notes')
          .doc(noteId)
          .delete();
      log('Note deleted successfully.');
    } catch (e) {
      log(e.toString());
    }
  }

  addNote(Map<String, Object> map) async {
    try {
      await _firestore
          .collection("Notes")
          .doc(_auth.currentUser?.uid.toString())
          .collection('notes')
          .add(map);
      log('Note edited successfully');
    } catch (e) {
      log('Failed to delete message: $e');
    }
  }

  Future<String> uploadImageToCloudinary(File file) async{
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

  updateNote(String id, Map<String, Object> map) async {
    try {
      await _firestore
          .collection("Notes")
          .doc(_auth.currentUser?.uid.toString())
          .collection('notes')
          .doc(id)
          .update(map);
      log('Note edited successfully');
    } catch (e) {
      log('Failed to delete message: $e');
    }
  }
}
