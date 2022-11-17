import 'package:flutter/material.dart';

class TextAreaWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClickedCopy;

  const TextAreaWidget({
    required this.text,
    required this.onClickedCopy,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 100,
            decoration: BoxDecoration(border: Border.all()),
            padding: const EdgeInsets.all(8),
            alignment: Alignment.center,
            child: SelectableText(
              text.isEmpty ? 'Scan an Image to get text' : text,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.copy, color: Colors.black),
          color: Colors.grey[200],
          onPressed: onClickedCopy,
        ),
      ],
    );
  }
}