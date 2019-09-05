/// A list BLoC with filtering but without pagination.
/// # Usage:
/// 1. Create ListBloc using [BlocProvider] or any other `DI` framework:
/// ```dart
/// BlocProvider(
///    builder: (context) => FilterListBloc<Data, Filter>(FilterDataRepository()),
///    child: DataPage(),
///  );
///// ```
/// 2. Load the data:
/// ```dart
/// filterListBloc = BlocProvider.of<ListBloc<Data, Filter>>(context)..loadElements(filter);
/// ```
/// 3. Use [ViewStateBuilder] to build your view state:
/// ```dart
///@override
///  Widget build(BuildContext context) {
///    return BlocBuilder(
///      bloc: filterListBloc,
///      builder: ListViewBuilder<Data>(
///        onLoading: (context) => _buildIndicator(),
///        onSuccess: (context, data) => _buildList(data),
///        onEmpty: (context) => _buildEmptyList(),
///        onError: (context, error) => _buildErrorMessage(error),
///      ).build,
///    );
/// ```
/// 4. Provide widgets corresponding loading, result, no result and error states.
///
///
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_patterns/src/common/view_state_builder.dart';

export 'package:flutter_bloc_patterns/src/common/view_state_builder.dart';
export 'package:flutter_bloc_patterns/src/list/base/list_view_refresh.dart';
export 'package:flutter_bloc_patterns/src/list/filter/filter_list_bloc.dart';
export 'package:flutter_bloc_patterns/src/list/filter/filter_list_repository.dart';
