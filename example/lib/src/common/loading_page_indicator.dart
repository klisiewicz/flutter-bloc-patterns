import 'package:flutter/material.dart';

class LoadingPageIndicator extends StatelessWidget {
  const LoadingPageIndicator({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 1.5),
          ),
        ),
      );
}
