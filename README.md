# Flutter BLoC patterns

[![Codemagic build status](https://api.codemagic.io/apps/5d28ebe2db95112ead3bbeb9/5d28ebe2db95112ead3bbeb8/status_badge.svg)](https://codemagic.io/apps/5d28ebe2db95112ead3bbeb9/5d28ebe2db95112ead3bbeb8/latest_build) [![Star on GitHub](https://img.shields.io/github/stars/klisiewicz/flutter-bloc-patterns.svg?style=flat&logo=github&colorB=deeppink&label=Stars)](https://github.com/klisiewicz/flutter-bloc-patterns) [![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](https://opensource.org/licenses/MIT)

---
A set of most common BLoC use cases build on top [flutter_bloc](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc) library.

## Features
### ListBloc
The most basic use case. Allows to fetch, refresh and display a list of elements without filtering and pagination. Thus, `ListBloc` should be used only with a reasonable amount of data. `ListBloc` provides the methods for loading and refreshing data: `loadElements()` and `refreshElements()`. The former is most suitable for initial data fetch or for retry action when the first fetch fails. The latter is designed for being called after the initial fetch succeeds. It can be performed when the list has already been loaded. To display the current view state `ListBloc` is coupled with a `Repository` and `ListViewBuilder`.
##### Repository
A `Repository` to handles data operations. It knows where to get the data from and what API calls to make when data is updated. A `Repository` can utilize a single data source as well as it can be a mediator between different data sources, such as database, web services and caches.
A `Repository` implementation should provide only one method:
`Future<List<T>> getAll();`
This method is responsible for providing all the data to the `ListBloc`.
##### ListViewBuilder
`ListViewBuilder` is responsible for building the UI based on the loading list result. It comes with a set of handy callbacks, which corresponds to the list state:
    * `onLoading` - informs the presentation layer that the list is loading, so it can display a loading indicator,
    * `onRefreshing` - informs the presentation layer that the list is refreshing, so it can display a refresh indicator or/and the current state of list elements,
    * `onResult` - informs the presentation layer that the loading is completed and a non empty list of elements was retrieved,
    * `onNoResult` - informs the presentation layer that the loading is completed, but no elements were retrieved,
    * `onError` - informs the presentation layer that the loading or refreshing has ended with an error. It also provides an exception that has occurred.

##### Usage
1. Create `ListBloc` using `BlocProvider` or any other `DI` framework:
    ```dart
    BlocProvider(
        builder: (context) => ListBloc<Data>(DataRepository()),
        child: _PostsPage(),
    );
    ```
2. Trigger loading the data:
    ```dart
    listBloc = BlocProvider.of<ListBloc<Data>>(context)..loadElements();
    ```
3. Use `ListViewBuilder` to build the view state:
    ```dart
    @override
    Widget build(BuildContext context) {
        return BlocBuilder(
            bloc: listBloc,
            builder: ListViewBuilder<Data>(
              onLoading: (context) => _buildIndicator(),
              onResult: (context, elements) _buildList(elements),
              onNoResult: (context) => _buildEmptyList(),
              onError: (context, error) => _buildErrorMessage(error),
            ).build,
        );
      }
    ```
4. Provide widgets corresponding to _loading_, _result_, _no result_ and _error states_.

##### See also
[List BLoC Sample App](example/lib/src/list_app.dart)

### FilterListBloc
An extension to the `ListBloc` that allows filtering.

##### FilterRepository
`FilterRepository` provides two methods:
`Future<List<T>> getAll();` - this method is called when a `null` filter is provided and should return all elements,
`Future<List<T>> getBy(F filter);` - this method is called with `nonnull` filter and should return only elements that match it.

#### Usage
Usage is mostly the same as `ListBloc` except of that `loadElements(F filter)` and `refreshElements(F filter)` accept an optional filter parameter.

##### See also
[Filter List BLoC Sample App](example/lib/src/filter_list_app.dart)

## Dart version

- Dart 2: >= 2.2.0

## Author
- [Karol Lisiewicz](https://github.com/klisiewicz)
