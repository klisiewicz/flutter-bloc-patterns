import 'package:flutter/widgets.dart';

class ErrorMessage extends StatelessWidget {
  final Object error;

  const ErrorMessage({required this.error, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error.toString()),
    );
  }
}
