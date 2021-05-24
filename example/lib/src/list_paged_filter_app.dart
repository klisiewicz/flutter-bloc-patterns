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

class PagedFilterListSampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paged Filter List Sample App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: BlocProvider(
        create: (_) => PagedListFilterBloc<Photo, Album>(
          PagedFilterPhotoRepository(),
        ),
        child: _PhotosPage(),
      ),
    );
  }
}

class _PhotosPage extends StatefulWidget {
  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<_PhotosPage> {
  final _myAlbum = const Album(id: 1);
  PagedListFilterBloc<Photo, Album> _photosBloc;

  @override
  void initState() {
    super.initState();
    _photosBloc = BlocProvider.of<PagedListFilterBloc<Photo, Album>>(context)
      ..loadFirstPage(
        pageSize: 12,
        filter: _myAlbum,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photos')),
      body: ViewStateBuilder<PagedList<Photo>, PagedListFilterBloc>(
        bloc: _photosBloc,
        onLoading: (context) => const LoadingIndicator(),
        onSuccess: (context, page) => PhotosListPaged(
          page,
          onLoadNextPage: _photosBloc.loadNextPage,
        ),
        onEmpty: (context) => const PhotosListEmpty(),
        onError: (context, error) => ErrorMessage(error: error),
      ),
    );
  }

  @override
  void dispose() {
    _photosBloc.close();
    super.dispose();
  }
}
