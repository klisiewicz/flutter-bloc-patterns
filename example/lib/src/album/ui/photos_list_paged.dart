import 'package:example/src/album/model/photo.dart';
import 'package:example/src/common/loading_page_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_patterns/paged_list.dart';
import 'package:infinite_widgets/infinite_widgets.dart';

class PhotosListPaged extends StatelessWidget {
  final PagedList<Photo> page;
  final VoidCallback onLoadNextPage;

  const PhotosListPaged(
    this.page, {
    Key key,
    @required this.onLoadNextPage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InfiniteListView.separated(
      itemBuilder: (context, index) => _PhotoGridItem(page.elements[index]),
      separatorBuilder: (context, index) => Divider(),
      itemCount: page.elements.length,
      hasNext: page.hasMoreElements,
      nextData: onLoadNextPage,
      loadingWidget: LoadingPageIndicator(),
    );
  }
}

class _PhotoGridItem extends StatelessWidget {
  final Photo photo;

  const _PhotoGridItem(this.photo, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(photo.thumbnailUrl),
      title: Text(photo.title),
    );
  }
}
