import 'package:flutter/material.dart';

class LikeBtn extends StatelessWidget{
  final bool isLiked;
  void Function()? onTap;
  LikeBtn({super.key, required this.isLiked, required onTap});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey,
      )
    );
  }
}