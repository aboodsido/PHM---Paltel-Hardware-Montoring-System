  import 'package:flutter/material.dart';

BoxDecoration bodyTopEdge() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(50),
        topRight: Radius.circular(50),
      ),
    );
  }
