import 'package:animate_do/animate_do.dart';
import 'package:christmas/home.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UserTile extends StatelessWidget {
  final User user;
  final double position;
  final double left;
  const UserTile(this.user, this.position, this.left, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      bottom: position,
      left: left,
      width: 300,
      height: 100,
      curve: Curves.ease,
      child: ListTile(
        leading: InkWell(
          onTap: () async {
            await launch("https://instagram.com/${user.username}");
          },
          child: FadeIn(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(
                user.imageUrl,
              ),
              backgroundColor: const Color(0xFFFFDC8B),
            ),
          ),
        ),
      ),
      duration: const Duration(seconds: 3),
    );
  }
}
