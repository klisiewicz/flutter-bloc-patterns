/// A basic list BLoC with no filtering or pagination.
/// # Usage:
/// 1. Wrap a widget using [BlocProvider]
/// /// ```dart
/// BlocProvider(
//    builder: (context) => ListBloc<Data>(DataRepository()),
//    child: DataPage(),
//  )
///// ```
/// 2. Load the data:
/// ```dart
/// listBloc = BlocProvider.of<ListBloc<Data>>(context)..loadItems();
/// ```
/// 3. Use [ListViewBuilder] to build your view state:
/// ```dart
///@override
//  Widget build(BuildContext context) {
//    return BlocBuilder(
//      bloc: listBloc,
//      builder: ListViewBuilder<Data>(
//        onLoading: (context) => _buildIndicator(),
//        onResult: (context, data) => _buildListItems(data),
//        onNoResult: (context) => _buildEmptyListItems(),
//        onError: (context, error) => _buildErrorMessage(error: error),
//      ).build,
//    );
/// ```
/// 4. Provide widgets corresponding loading, result, no result and error states.
///
/// See also:
/// [FilterListSampleApp] for more details.
///
library flutter_list_bloc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_view_builder.dart';
export 'package:flutter_bloc_patterns/src/list/base/list_bloc.dart';
export 'package:flutter_bloc_patterns/src/list/base/list_view_builder.dart';
export 'package:flutter_bloc_patterns/src/list/base/list_view_refresh.dart';
export 'package:flutter_bloc_patterns/src/list/base/repository.dart';
