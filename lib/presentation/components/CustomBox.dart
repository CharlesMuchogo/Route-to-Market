
import 'package:flutter/material.dart';

class CenteredColumn extends StatelessWidget {
  final  Widget content;
  const CenteredColumn({ super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
      child: content
    );
  }
}
