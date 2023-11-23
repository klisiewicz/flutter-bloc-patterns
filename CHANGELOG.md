
# Changelog

## [0.13.0]

**Breaking Changes!**

* Removed the direct export `page.dart`. It's now included in `paged_list.dart` and `paged_filter_list.dart`,
* Removed export of `view_state`,
* Replaced `ViewStateBuilder` builders:
  * `onReady` -> `initial`
  * `onLoading` -> `loading`
  * `onRefreshing` -> `refreshing`
  * `onSuccess` -> `data`
  * `onEmpty` -> `empty`
  * `onError` -> `error`
* Replaced `ConnectionBuilder` builders:
  * `onOnline` -> `online`
  * `onOffline` -> `offline`
* Replaced `ViewStateListener` callbacks:
  * `onSuccess` -> `onData` 

## [0.12.0]

**Breaking Changes!**

* Migrated to `dart` 3.0,
* Removed: `@Deprecated` methods,
* Removed: export of `ListEvent`, `DetailsEvent` and `PagedListEvent`,
* Changed: Repositories to `interface` classes.

## [0.11.0]

* Migrated to `bloc` 8.1.x and `flutter_bloc` 8.1.x,
* Added `ConnectionBloc` - a BLoC that exposes the Internet connection state to the UI.

## [0.10.0]

* Migrated to `bloc` 8.0.x and `flutter_bloc` 8.0.x,

## [0.9.0]

**Breaking Changes!**

* Migrated to `bloc` 7.0.0 and `flutter_bloc` 7.0.1,
* Migrated to `null-safety`.

## [0.8.0]

**Breaking Changes!**

* Migrated to `bloc` 6.1.1 and `flutter_bloc` 6.1.1.

## [0.7.0]

**Breaking Changes!**

* Migrated to `bloc` 5.0.1 and `flutter_bloc` 5.0.1.

## [0.6.0]

**Breaking Changes!**

* Changed `Page` should be imported via `package:flutter_bloc_patterns/page.dart`.

## [0.5.0]

**Breaking Changes!**

* Changed: `RefreshView`, `ViewState` and `ViewStateBuilder` should be imported  
  via `package:flutter_bloc_patterns/view.dart`,
* Changed: `ViewStateListener` for handling features that need to occur once per state change such  
  as navigation, showing a `SnackBar`, showing a `Dialog`, etc,
* Added: `const` constructors for `ViewState`.

## [0.4.0]

* Migrated: to `bloc` 3.0.0 and `flutter_bloc` 3.2.0,
* Changed: Rethrowing `errors` from `blocs` to make them available in the `onError` method,

## [0.3.1]

* Added: `ViewState` exported.

## [0.3.0]

* Added: `PagedFilterListBloc` - a list BLoC with pagination and filtering,
* Changed: `PagedRepository` renamed to `PagedListRepository`.
* Changed: `FilterRepository` renamed to `FilterListRepository`.
* Migrated to `bloc` 2.0.0 and `flutter_bloc` 2.0.1

## [0.2.2]

* Migrated to `bloc` 1.0.0 and `flutter_bloc` 1.0.0

## [0.2.1]

* Migrated to `bloc` 0.16.1 and `flutter_bloc` 0.22.0

## [0.2.0]

* Added: `Initial` state introduced along with `onReady` callback for the `ViewStateBuilder`,
* Changed: `Repository` renamed to `ListRepository`,

## [0.1.1]

* Formatting issues fixed.

## [0.1.0]

* Added: `ListBloc` - a basic list BLoC with no filtering nor pagination,
* Added: `FilterListBloc` - a list BLoC with filtering, but without pagination,
* Added: `PagedListBloc` - a list BLoC with pagination but without filtering,
* Added: `DetailsBloc` - a BLoC that allows to fetch a single element with given identifier.