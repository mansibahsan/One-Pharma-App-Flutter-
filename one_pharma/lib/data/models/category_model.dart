import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final int itemCount;
  final Color tintColor;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.itemCount,
    this.tintColor = const Color(0xFFFF4858),
  });
}
