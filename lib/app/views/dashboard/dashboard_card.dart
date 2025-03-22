import 'package:flutter/material.dart';

Widget buildCard({
  required String title,
  required String number,
  required IconData icon,
  required Color color,
  required Color circleColor,
}) {
  return GestureDetector(
    child: Container(
      margin: const EdgeInsets.only(bottom: 16), // Space between cards
      padding: const EdgeInsets.all(16), // Padding inside the card
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4), // Slight shadow below the card
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Spreads items
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns to the left
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8), // Space between title and number
              Text(
                number,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: circleColor,
            radius: 24, // Circle size
            child: Icon(
              icon,
              color: color,
              size: 28, // Icon size
            ),
          ),
        ],
      ),
    ),
  );
}
