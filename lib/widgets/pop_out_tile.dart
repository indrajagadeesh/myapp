// lib/widgets/pop_out_tile.dart

import 'package:flutter/material.dart';

class PopOutTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const PopOutTile({
    required this.icon,
    required this.title,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: onTap,
    );
  }
}
