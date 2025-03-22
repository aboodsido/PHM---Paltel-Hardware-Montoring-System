import 'package:flutter/material.dart';

Widget buildCountCard(String count, Color color, bool isSelected) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 2),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: isSelected ? color : Colors.white, width: 1.5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          CircleAvatar(backgroundColor: color, radius: 5),
          const SizedBox(height: 7),
          Text('$count Devices'),
        ],
      ),
    ),
  );
}
