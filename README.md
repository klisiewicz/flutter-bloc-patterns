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
`ViewStateBuilder` is responsible for building the UI based on the view state. It's a wrapper over the `BlocBuilder` widget so it accepts a `bloc` object and a set of handy callbacks, which corresponds to each possible state:

* `onReady` - informs the presentation layer that view is in it's initial state, and no action has taken place yet,
* `onLoading` - informs the presentation layer that the data is being loaded, so it can display a loading indicator,
* `onRefreshing` - informs the presentation layer that the data is being refreshed, so it can display a refresh indicator or/and the current state of list elements,
* `onSuccess` - informs the presentation layer that the loading is completed and a `nonnull` and not empty data was retrieved,
* `onEmpty` - informs the presentation layer that the loading is completed, but `null` or empty data was retrieved,
* `onError` - informs the presentation layer that the loading or refreshing has ended with an error. It also provides an error that has occurred.

## Features

### ListBloc
The most basic use case. Allows to fetch, refresh and display a list of elements without filtering and pagination. Thus, `ListBloc` should be used only with a reasonable amount of data. `ListBloc` provides the methods for loading and refreshing data: `loadElements()` and `refreshElements()`. The former is most suitable for initial data fetch or for retry action when the first fetch fails. The latter is designed for being called after the initial fetch succeeds. It can be performed when the list has already been loaded. To display the current view state `ListBloc` cooperates with `BlocBuilder` as well as `ViewStateBuilder`.

##### ListRepository

A `ListRepository` implementation should provide only one method:

`Future<List<T>> getAll();` - this method is responsible for providing all the data to the `ListBloc`.

Where:
* `T` is the element type returned by this repository.

##### Usage

[List BLoC Sample App](example/lib/src/list_app.dart)

### FilterListBloc
An extension to the `ListBloc` that allows filtering.

##### FilterRepository

`FilterListRepository` provides two methods:

`Future<List<T>> getAll();` - this method is called when a `null` filter is provided and should return all elements,
`Future<List<T>> getBy(F filter);` - this method is called with `nonnull` filter and should return only elements that match it.

Where:
* `T` is the element type returned by this repository,
* `F` is the filter type, which can be primitive as well as complex object.

#### Usage

[Filter List BLoC Sample App](example/lib/src/list_filter_app.dart)

### PagedListBloc
A list BLoC with pagination but without filtering. It works best with [Infinite Widgets](https://github.com/jaumard/infinite_widgets) but a custom presentation layer can provided as well.

#### Page
Contains information about the current page, this is `number` and `size`.

#### PagedList
List of elements with information if there are more elements or not.

#### PagedListRepository
`PagedListRepository` comes with only one method:

`Future<List<T>> getAll(Page page);` - this method retrieves elements meeting the pagination restriction provided by the `page` object.
When elements are exceeded it should return an empty list or throw `PageNotFoundException`. `PagedListBloc` will handle both cases in the same way.

Where:
* `T` is the element type returned by this repository.

#### Usage

[Paged List BLoC Sample App](example/lib/src/list_paged_app.dart)

### PagedListFilterBloc
A list BLoC with pagination and filtering. It works best with [Infinite Widgets](https://github.com/jaumard/infinite_widgets) but a custom presentation layer can provided as well.

#### Page
Contains information about the current page, this is `number` and `size`.

#### PagedList
List of elements with information if there are more elements or not.

#### PagedListFilterRepository
`PagedListFilterRepository` provides only two methods:

`Future<List<T>> getAll(Page page);` - retrieves elements meeting the pagination restriction provided by the `page` object.
`Future<List<T>> getBy(Page page, F filter);` - retrieves elements meeting pagination as well as the filter restrictions provided by the `page` and `filter` objects.

When elements are exceeded it should return an empty list or throw `PageNotFoundException`. `PagedListFilterBloc` will handle both cases in the same way.

Where:
* `T` is the element type returned by this repository,
* `F` is the filter type, which can be primitive as well as complex object.

#### Usage

[Paged List BLoC Sample App](example/lib/src/list_paged_filter_app.dart)

### DetailsBloc
A BLoC that allows to fetch a single element with given identifier.

#### DetailsRepository
`DetailsRepository` comes with only one method:

`Future<T> getById(I id);` - this method retrieves an element with given id. When there's no element matching the id the `null` should be returned or `ElementNotFoundException` should be thrown. In both cases the `DetailsBloc` will emit `Empty` state.

Where:
* `T` is the element type returned by this repository,
* `I` is the id type, it can be primitive as well as a complex object.

#### Usage:

[List/Details BLoC Sample App](example/lib/src/list_details_app.dart)

## Dart version

- Dart 2: >= 2.2.0

## Author
- [Karol Lisiewicz](https://github.com/klisiewicz)
