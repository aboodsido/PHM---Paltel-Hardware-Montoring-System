import 'package:flutter/material.dart';

import 'shimmer_widget.dart';

ListView listShimmerLoading(double hight) {
  return ListView.builder(
    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
    itemCount: 10,
    itemBuilder:
        (context, index) => Card(
          child: ShimmerLoading.rectangular(
            height: hight,
            shapeBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
  );
}
