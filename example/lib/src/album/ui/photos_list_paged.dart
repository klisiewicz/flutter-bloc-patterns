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
    super.key,
    required this.onLoadNextPage,
  });

  @override
  Widget build(BuildContext context) {
    return InfiniteListView.separated(
      itemBuilder: (context, index) => PhotoGridItem(page.items[index]),
      separatorBuilder: (context, index) => const Divider(),
      itemCount: page.items.length,
      hasNext: page.hasMoreItems,
      nextData: onLoadNextPage,
      loadingWidget: const LoadingPageIndicator(),
    );
  }
}

class PhotoGridItem extends StatelessWidget {
  final Photo photo;

  const PhotoGridItem(
    this.photo, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.network(photo.thumbnailUrl),
      title: Text(photo.title),
    );
  }
}
