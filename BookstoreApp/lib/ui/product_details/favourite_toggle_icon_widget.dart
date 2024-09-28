import 'package:flutter/material.dart';

class FavoriteToggleIcon extends StatefulWidget {
  const FavoriteToggleIcon({super.key});

  @override
  _FavoriteToggleIconState createState() => _FavoriteToggleIconState();
}

class _FavoriteToggleIconState extends State<FavoriteToggleIcon> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          favorite = !favorite;
        });
      },
      child: Icon(
        favorite ? Icons.favorite : Icons.favorite_border,
        color: favorite ? Colors.redAccent : Colors.redAccent,
        size: 30,
      ),
    );
  }
}
