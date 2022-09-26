import 'package:flutter_test/flutter_test.dart';

import 'view_state_keys.dart';

void verifyReadyWidgetIsDisplayed() =>
    expect(find.byKey(readyKey), findsOneWidget);

void verifyLoadingWidgetIsDisplayed() =>
    expect(find.byKey(loadKey), findsOneWidget);

void verifyRefreshWidgetIsDisplayed() =>
    expect(find.byKey(refreshKey), findsOneWidget);

void verifyEmptyWidgetIsDisplayed() =>
    expect(find.byKey(emptyKey), findsOneWidget);

void verifySuccessWidgetIsDisplayed() =>
    expect(find.byKey(successKey), findsOneWidget);

void verifyErrorWidgetIsDisplayed() =>
    expect(find.byKey(errorKey), findsOneWidget);
