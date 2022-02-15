import 'package:flutter/material.dart';

class PhotosListEmpty extends StatelessWidget {
  const PhotosListEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No photos found'),
    );
  }
}
