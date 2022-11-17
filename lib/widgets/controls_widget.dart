import 'package:flutter/material.dart';

class ControlsWidget extends StatelessWidget {
  final VoidCallback onClickedPickImage;
  final VoidCallback onClickedScanText;
  final VoidCallback onClickedClear;

  const ControlsWidget({
    required this.onClickedPickImage,
    required this.onClickedScanText,
    required this.onClickedClear,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: onClickedPickImage,
          child: const Text('Pick Image'),
        ),

        const SizedBox(width: 12),

        ElevatedButton(
          onPressed: onClickedScanText,
          child: const Text('Scan For Text'),
        ),

        const SizedBox(width: 12),

        ElevatedButton(
          onPressed: onClickedClear,
          child: const Text('Clear'),
        )
      ],
    );
  }
}