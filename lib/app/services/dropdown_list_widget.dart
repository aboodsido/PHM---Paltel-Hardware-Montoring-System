import 'package:flutter/material.dart';

Expanded buildDropdownListWidget({
  required dynamic value,
  required List<DropdownMenuItem<String>> items,
  required Function(dynamic) onChanged,
}) {
  return Expanded(
    child: DropdownButtonFormField<String>(
      isExpanded: true,
      value: "$value",
      onChanged: onChanged,
      items: items,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 1),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      dropdownColor: Colors.white,
      iconEnabledColor: Colors.blue,
    ),
  );
}
