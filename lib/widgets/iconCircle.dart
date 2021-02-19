import 'package:flutter/material.dart';

class IconCircle extends StatelessWidget {
  final IconData iconData;
  final Color color;

  const IconCircle(this.iconData,this.color);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow:  [
          BoxShadow(
            color: color,
            blurRadius: 2.0,
          ),
          const BoxShadow(
            blurRadius: 3.0,
          ),
        ],
        shape: BoxShape.circle,
        border: Border.all(
          color:  color,
          width: 2,
        ),
      ),
      child:  Icon(
        iconData,
        color: color,
      ),
    );
  }
}

