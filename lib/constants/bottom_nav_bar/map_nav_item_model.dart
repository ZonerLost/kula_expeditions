import 'package:flutter/material.dart';

class MapNavItemModel {
  final String label;
  final String icon;
  final IconData? iconData;

  const MapNavItemModel({
    required this.label,
    required this.icon,
    this.iconData,
  });
}