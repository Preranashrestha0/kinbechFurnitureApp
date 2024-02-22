import 'package:flutter/material.dart';

class ExpandDivider extends StatelessWidget {
  const ExpandDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0),
      child: Row(
        children: [
          Expanded(
            child: Divider( //its kind of a line
              thickness: 2.8,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
