# Flutter BLoC patterns

[![Codemagic build status](https://api.codemagic.io/apps/5d28ebe2db95112ead3bbeb9/5d28ebe2db95112ead3bbeb8/status_badge.svg)](https://codemagic.io/apps/5d28ebe2db95112ead3bbeb9/5d28ebe2db95112ead3bbeb8/latest_build) [![Star on GitHub](https://img.shields.io/github/stars/klisiewicz/flutter-bloc-patterns.svg?style=flat&logo=github&colorB=deeppink&label=Stars)](https://github.com/klisiewicz/flutter-bloc-patterns) [![License: MIT](https://img.shields.io/badge/License-MIT-purple.svg)](https://opensource.org/licenses/MIT)

---
A set of most common BLoC use cases build on top [flutter_bloc](https://github.com/felangel/bloc/tree/master/packages/flutter_bloc) library.

## Key contepts

##### BLoC
BLoC, aka **B**usiness **Lo**gic **C**omponent, is a state management system for Flutter. It's main goal is to separate business logic from the presentation layer. The BLoC handles user actions or any other events and generates new state for the view to render.

##### Repository
A `Repository` to handles data operations. It knows where to get the data from and what API calls to make when data is updated. A `Repository` can utilize a single data source as well as it can be a mediator between different data sources, such as database, web services and caches.

##### ViewStateBuilder
`ViewStateBuilder` is responsible for building the UI based on the view state. It comes with a set of handy callbacks, which corresponds to each possible state:

* `onLoading` - informs the presentation layer that the list is loading, so it can display a loading indicator,
* `onRefreshing` - informs the presentation layer that the list is refreshing, so it can display a refresh indicator or/and the current state of list elements,
* `onSuccess` - informs the presentation layer that the loading is completed and a `nonnull` and not empty data was retrieved,
* `onEmpty` - informs the presentation layer that the loading is completed, but `null` or empty data was retrieved,
* `onError` - informs the presentation layer that the loading or refreshing has ended with an error. It also provides an error that has occurred.

## Features

### ListBloc
The most basic use case. Allows to fetch, refresh and display a list of elements without filtering and pagination. Thus, `ListBloc` should be used only with a reasonable amount of data. `ListBloc` provides the methods for loading and refreshing data: `loadElements()` and `refreshElements()`. The former is most suitable for initial data fetch or for retry action when the first fetch fails. The latter is designed for being called after the initial fetch succeeds. It can be performed when the list has already been loaded. To display the current view state `ListBloc` cooperates with `BlocBuilder` as well as `ViewStateBuilder`.

##### Repository
A `Repository` implementation should provide only one method:
`Future<List<T>> getAll();`
This method is responsible for providing all the data to the `ListBloc`.

##### Usage
1. Create `ListBloc` using `BlocProvider` or any other `DI` framework:

```dart
BlocProvider(
    builder: (context) => ListBloc<Data>(DataRepository()),
    child: DataPage(),
);
```

2. Trigger loading data. Typically it can be done in the `StatefulWidget`'s `initState` method:

```dart
listBloc = BlocProvider.of<ListBloc<Data>>(context)..loadElements();
```

3. Use `BlocBuilder` along with the `ViewStateBuilder` to build the view state:

```dart
@override
Widget build(BuildContext context) {
    return BlocBuilder(
        bloc: listBloc,
        builder: ViewStateBuilder<Data>(
          onLoading: (context) => _buildIndicator(),
          onSuccess: (context, elements) _buildList(elements),
          onEmpty: (context) => _buildEmptyList(),
          onError: (context, error) => _buildErrorMessage(error),
        ).build,
    );
}
```

4. Provide widgets corresponding to _loading_, _success_, _empty_ and _error_ states.

##### See also
[List BLoC Sample App](example/lib/src/list_app.dart)

### FilterListBloc
An extension to the `ListBloc` that allows filtering.

##### FilterRepository
`FilterRepository` provides two methods:

`Future<List<T>> getAll();` - this method is called when a `null` filter is provided and should return all elements,
`Future<List<T>> getBy(F filter);` - this method is called with `nonnull` filter and should return only elements that match it.

#### Usage
1. Create `FilteredListBloc` using `BlocProvider` or any other `DI` framework:

```dart
BlocProvider(
    builder: (context) => FilteredListBloc<Data>(FilterDataRepository()),
    child: DataPage(),
);
```
    
2. Trigger loading data with the initial filter value. The `filter` parameter is optional and when it's not provided all elements from the `repository` will be fetched.

```dart
filteredListBloc = BlocProvider.of<FilteredListBloc<Data>>(context)..loadElements(filter: initialFilter);
```

##### See also
[Filter List BLoC Sample App](example/lib/src/list_filter_app.dart)

### PagedListBloc
A list BLoC with pagination but without filtering.

#### Page
Contains information about the current page, this is `number` and `size`.

#### PagedList
List of elements with information whether there could be even more elements.

#### PagedRepository
`PagedRepository` comes with only one method:

`Future<List<T>> getAll(Page page);` - this method retrieves elements meeting the pagination restriction provided by the `page` object. When elements are exceeded it should return an empty list or throw `PageNotFoundException`. `PagedListBloc` will hande both cases in the same way.

#### Usage
1. Create `PagedListBloc` using `BlocProvider` or any other `DI` framework:

2. Trigger loading first page. This is the place, where you can set the page size. Once set it cannot be changed.

```dart
listBloc = BlocProvider.of<PagedListBloc<Data>>(context)..loadFirstPage(pageSize: 10);
```
3. Use `ViewStateBuilder` to build the view state.

##### See also
[Paged List BLoC Sample App](example/lib/src/list_paged_app.dart)

## Dart version

- Dart 2: >= 2.2.0

## Author
- [Karol Lisiewicz](https://github.com/klisiewicz)
