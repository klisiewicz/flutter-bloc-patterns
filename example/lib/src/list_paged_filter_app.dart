import 'package:example/src/album/model/album.dart';
import 'package:example/src/album/model/photo.dart';
import 'package:example/src/album/model/photo_repository.dart';
import 'package:example/src/album/ui/photos_list_empty.dart';
import 'package:example/src/album/ui/photos_list_paged.dart';
import 'package:example/src/common/error_message.dart';
import 'package:example/src/common/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/paged_filter_list.dart';
import 'package:flutter_bloc_patterns/view.dart';

void main() => runApp(PagedFilterListSampleApp());

typedef PhotosBloc = PagedListFilterBloc<Photo, Album>;

class PagedFilterListSampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paged Filter List Sample App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: BlocProvider(
        create: (_) {
          return PhotosBloc(PagedFilterPhotoRepository())
            ..loadFirstPage(pageSize: 12, filter: const Album(id: 1));
        },
        child: _PhotosPage(),
      ),
    );
  }
}

class _PhotosPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photos')),
      body: ViewStateBuilder<PagedList<Photo>, PhotosBloc>(
        loading: (context) => const LoadingIndicator(),
        data: (context, page) => PhotosListPaged(
          page,
          onLoadNextPage: context.read<PhotosBloc>().loadNextPage,
        ),
        empty: (context) => const PhotosListEmpty(),
        error: (context, error) => ErrorMessage(error: error),
      ),
    );
  }
}
