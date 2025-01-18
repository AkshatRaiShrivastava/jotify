import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jotify/components/profile_pic.dart';
import 'package:jotify/services/auth%20service/auth_service.dart';

class MyTopBar extends StatefulWidget {
  final String? Function(String val)? onChanged;
  const MyTopBar({super.key, this.onChanged});

  @override
  State<MyTopBar> createState() => _MyTopBarState();
}

class _MyTopBarState extends State<MyTopBar> {
  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Container(
      padding: const EdgeInsets.only(top: 45, left: 10, right: 10, bottom: 15),
      decoration: BoxDecoration(
          color: Colors.white54.withOpacity(0.2),
          borderRadius: BorderRadius.circular(18)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const MyProfilePic(),
               Expanded(child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                      hintText: 'Search notes...',
                      hintStyle: const TextStyle(color: Colors.black45),
                      prefixIcon: Icon(Icons.search),
                      fillColor: Colors.white.withOpacity(0.3),
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none
                      )
                  ),
                ),
              ),),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: IconButton(
                  onPressed: () {
                    showCupertinoModalPopup(
                        context: context,
                        builder: (context) => CupertinoActionSheet(
                              actions: [
                                CupertinoActionSheetAction(
                                  onPressed: () {
                                    authService.signout();
                                    Navigator.of(context).pop();
                                  },
                                  isDestructiveAction: true,
                                  child: Text('Logout'),
                                ),
                              ],
                            ));
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: const [
              Text(
                'Capture Ideas,\nAnytime, Anywhere',
                style: TextStyle(
                  fontSize: 34,
                  letterSpacing: 1.5,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
