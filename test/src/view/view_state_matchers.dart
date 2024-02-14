import 'package:flutter_test/flutter_test.dart';

import 'view_state_keys.dart';

void verifyInitialWidgetIsDisplayed() =>
    expect(find.byKey(initialKey), findsOneWidget);

void verifyLoadingWidgetIsDisplayed() =>
    expect(find.byKey(loadKey), findsOneWidget);

void verifyRefreshWidgetIsDisplayed() =>
    expect(find.byKey(refreshKey), findsOneWidget);

void verifyEmptyWidgetIsDisplayed() =>
    expect(find.byKey(emptyKey), findsOneWidget);

void verifyDataWidgetIsDisplayed() =>
    expect(find.byKey(dataKey), findsOneWidget);

void verifyErrorWidgetIsDisplayed() =>
    expect(find.byKey(errorKey), findsOneWidget);
