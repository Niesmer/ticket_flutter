import 'package:flutter/material.dart';

class LikeBtn extends StatelessWidget {
  final bool isLiked;
  final void Function()? onTap;
  final void Function()? onLiked; // Add a new callback for liked event

  const LikeBtn({
    super.key,
    required this.isLiked,
    required this.onTap,
    this.onLiked, // Initialize the new callback
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
        if (onLiked != null) {
          onLiked!(); // Call the liked callback
        }
      },
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Color.fromARGB(255, 2, 78, 218) : Colors.grey,
      ),
    );
  }
}
