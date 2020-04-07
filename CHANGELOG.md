## [0.6.0] * Breaking Changes *

* `Page` should be imported via `package:flutter_bloc_patterns/page.dart`,

## [0.5.0] * Breaking Changes *

* `RefreshView`, `ViewState` and `ViewStateBuilder` should be imported via `package:flutter_bloc_patterns/view.dart`,
* `ViewStateListener` for handling features that need to occur once per state change such as navigation, showing a `SnackBar`, showing a `Dialog`, etc,
* `const` constructors for `ViewState`.

## [0.4.0]

* Migrating to `bloc` 3.0.0 and `flutter_bloc` 3.2.0,
* Rethrowing `errors` from `blocs` to make them available in the `onError` method,
* Code style improvements.

## [0.3.1]

* `ViewState` exported.

## [0.3.0]

* `PagedFilterListBloc` - a list BLoC with pagination and filtering,
* `PagedRepository` renamed to `PagedListRepository`.
* `FilterRepository` renamed to `FilterListRepository`.
* Migrating to `bloc` 2.0.0 and `flutter_bloc` 2.0.1

## [0.2.2]

* Migrating to `bloc` 1.0.0 and `flutter_bloc` 1.0.0

## [0.2.1]

* Migrating to `bloc` 0.16.1 and `flutter_bloc` 0.22.0

## [0.2.0]

* `Initial` state introduced along with `onReady` callback for the `ViewStateBuilder`,
* `Repository` renamed to `ListRepository`,

## [0.1.1]

* Formatting issues fixed.

## [0.1.0]

* `ListBloc` - a basic list BLoC with no filtering nor pagination,
* `FilterListBloc` - a list BLoC with filtering, but without pagination,
* `PagedListBloc` - a list BLoC with pagination but without filtering,
* `DetailsBloc` - a BLoC that allows to fetch a single element with given identifier.
