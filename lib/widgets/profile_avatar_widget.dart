import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  final String url;
  final double? radius, size;
  final Color? iconColor;
  const ProfileAvatarWidget({super.key, required this.url, this.iconColor, this.radius, this.size});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 15,

      backgroundImage: NetworkImage(
        url,
        // fit: BoxFit.contain,
      ),
      onBackgroundImageError: (a,b) {
    
      },
      child: url.isEmpty ? Icon(
        Icons.person,
        size: size ?? 20,
        color: iconColor,
      ): null,
    );
  }
}

// Hello I am Tamim