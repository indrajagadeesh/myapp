// lib/widgets/pop_out_tile.dart

import 'package:flutter/material.dart';

class PopOutTile extends StatelessWidget {
  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  PopOutTile({
    required this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: leading,
        title: Text(title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: subtitle != null
            ? Text(subtitle!, style: TextStyle(fontSize: 14))
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}