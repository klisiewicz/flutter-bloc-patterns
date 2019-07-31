/// A basic list BLoC with no filtering nor pagination.
/// # Usage:
/// 1. Create ListBloc using [BlocProvider] or any other `DI` framework:
/// ```dart
/// BlocProvider(
///    builder: (context) => ListBloc<Data>(DataRepository()),
///    child: DataPage(),
///  );
/// ```
/// 2. Load the data:
/// ```dart
/// listBloc = BlocProvider.of<ListBloc<Data>>(context)..loadItems();
/// ```
/// 3. Use [ListViewBuilder] to build the view state:
/// ```dart
///@override
///  Widget build(BuildContext context) {
///    return BlocBuilder(
///      bloc: listBloc,
///      builder: ListViewBuilder<Data>(
///        onLoading: (context) => _buildIndicator(),
///        onResult: (context, data) => _buildListItems(data),
///        onNoResult: (context) => _buildEmptyListItems(),
///        onError: (context, error) => _buildErrorMessage(error: error),
///      ).build,
///    );
/// ```
/// 4. Provide widgets corresponding loading, result, no result and error states.
///
library flutter_list_bloc;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/list/base/list_view_builder.dart';
export 'package:flutter_bloc_patterns/src/list/base/list_bloc.dart';
export 'package:flutter_bloc_patterns/src/list/base/list_view_builder.dart';
export 'package:flutter_bloc_patterns/src/list/base/list_view_refresh.dart';
export 'package:flutter_bloc_patterns/src/list/base/repository.dart';
