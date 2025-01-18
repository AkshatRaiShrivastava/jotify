import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jotify/components/top_bar.dart';
import 'package:jotify/services/notes%20service/note_service.dart';

import 'note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  NoteService noteService = NoteService();
  String _searchQuery = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: OvalBorder(),
        onPressed: () {
          Navigator.of(context).pushNamed('/noteDetails');
        },
        child: Icon(
          Icons.add_rounded,
          size: 35,
          color: Colors.black87,
        ),
        backgroundColor: Color.fromRGBO(190, 147, 226, 1),
      ),
      body: SafeArea(
        bottom: false,
        top: false,
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                  'https://images.pexels.com/photos/7135057/pexels-photo-7135057.jpeg'),
              fit: BoxFit.fitHeight,
            ),
          ),
          child: Column(
            children: [
              // MyTopBar stays on top
              MyTopBar(
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                    print(_searchQuery);
                  });
                  return null;
                },
              ),
              // Expanded widget ensures the notes grid takes up the remaining space
              Expanded(child: buildNotesList()),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotesList() {
    return StreamBuilder(
      stream: noteService.getAllNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading notes.'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white12,
            ),
          );
        }
        var notes = snapshot.data!.docs.where((doc) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          String title = data['title'].toLowerCase();
          String body = data['body'].toLowerCase();
          return title.contains(_searchQuery) || body.contains(_searchQuery);
        }).toList();

        if (notes.isEmpty) {
          return Center(
            child: Text(
              "No notes found",
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.only(top: 20, bottom: 100),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3,
            mainAxisSpacing: 7,
            childAspectRatio: 3 / 4,
          ),
          itemCount: notes.length,
          itemBuilder: (context, index) {
            return buildNoteItem(notes[index]);
          },
        );
      },
    );
  }

  Widget buildNoteItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp timestamp = data['timestamp'];
    DateTime time = timestamp.toDate();
    String formattedTime = DateFormat('EEE, dd/MM/yy').format(time);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteDetailScreen(note: doc),
          ),
        );
      },
      onLongPress: () {
        showCupertinoModalPopup(
            context: context,
            builder: (context) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NoteDetailScreen(note: doc),
                          ),
                        );
                      },
                      child: Text('Edit'),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        noteService.deleteMessage(doc.id);
                        Navigator.of(context).pop();
                      },
                      child: Text('Delete'),
                      isDestructiveAction: true,
                    ),
                  ],
                ));
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            image: DecorationImage(
                image: CachedNetworkImageProvider(data['imageUrl'],
                    maxHeight: 100),
                fit: BoxFit.cover,
                opacity: 0.7),
            color: Colors.white54.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data['title'],
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 5),
              Text(
                data['body'],
                style: const TextStyle(fontSize: 16, color: Colors.black),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Text(
                formattedTime,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
