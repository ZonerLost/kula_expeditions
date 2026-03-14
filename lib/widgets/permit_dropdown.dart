// permit_dropdown.dart

import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

class PermitDropdown extends StatelessWidget {

  final String title;
  final String value;
  final List<String> items;
  final Function(String?) onChanged;

  const PermitDropdown({
    super.key,
    required this.title,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Text(
          title,
          style: AppTextStyles.title.copyWith(
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 6),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xffdcdcdc)),
            borderRadius: BorderRadius.circular(30),
          ),

          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down),

              items: items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),

              onChanged: onChanged,
            ),
          ),
        ),

        const SizedBox(height: 20)
      ],
    );
  }
}