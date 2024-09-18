import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RatingIcon extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RatingIconState();
}

class _RatingIconState extends State<RatingIcon> {
  int _rating = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              _rating = index + 1;
            });
          },
          child: Icon(
            index < _rating ? FontAwesomeIcons.solidStar : FontAwesomeIcons.star,
            color: Color(0xFF629bd0),
            size: 20,
          ),
        );
      }),
    );
  }
}
