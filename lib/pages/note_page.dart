import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jotify/services/notes%20service/note_service.dart';

class NoteDetailScreen extends StatefulWidget {
  final DocumentSnapshot? note;

  const NoteDetailScreen({Key? key, this.note}) : super(key: key);

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final NoteService noteService = NoteService();
  bool isLoading = false;
  File? _selectedImage;
  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      Map<String, dynamic> data = widget.note!.data() as Map<String, dynamic>;
      _titleController.text = data['title'] ?? '';
      _bodyController.text = data['body'] ?? '';
      _imageUrl = data['imageUrl']; // Load existing image URL
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    try {
      _imageUrl = await noteService.uploadImageToCloudinary(_selectedImage!);
    } catch (e) {
      print('Image upload error: $e');
    }
  }

  Future<void> saveNote() async {
    isLoading = true;
    String title = _titleController.text.trim();
    String body = _bodyController.text.trim();

    if (title.isEmpty && body.isEmpty && _imageUrl == null) {
      Navigator.pop(context);
      return;
    }

    try {
      if (_selectedImage != null) {
        await _uploadImage(); // Upload the image and set _imageUrl
      }

      if (widget.note == null) {
        await noteService.addNote({
          'title': title,
          'body': body,
          'imageUrl': _imageUrl.toString(),
          'timestamp': Timestamp.now(),
        });
      } else {
        await noteService.updateNote(widget.note!.id, {
          'title': title,
          'body': body,
          'imageUrl': _imageUrl.toString(),
          'timestamp': Timestamp.now(),
        });
      }

      Navigator.pop(context);
    } catch (e) {
      print('Error saving note: $e');
    }
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(CupertinoIcons.chevron_left_circle_fill)),
        title: Text(widget.note == null ? 'New Note' : 'Edit Note'),
        actions: [
          IconButton(
            icon: isLoading
                ? CircularProgressIndicator()
                : Icon(
                    CupertinoIcons.doc_checkmark_fill,
                    color: Colors.black,
                  ),
            onPressed: () {
              saveNote();
              setState(() {});
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Image Picker Section
            GestureDetector(
              onTap: _pickImage,
              child: _selectedImage != null
                  ? Image.file(
                      _selectedImage!,
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : _imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: _imageUrl!,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 50,
                          ),
                        )
                      : Container(
                          height: 200,
                          width: double.infinity,
                          child: const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 50,
                          ),
                        ),
            ),
            const SizedBox(height: 10),
            // Title Field
            TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: 'Title',
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            // Body Field
            Expanded(
              child: TextField(
                controller: _bodyController,
                style: const TextStyle(fontSize: 18),
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: 'Write your note here...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
