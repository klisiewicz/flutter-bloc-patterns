import 'package:flutter_test/flutter_test.dart';

import 'view_state_keys.dart';

void expectReadyWidgetIsDisplayed() =>
    expect(find.byKey(readyKey), findsOneWidget);

void expectLoadingWidgetIsDisplayed() =>
    expect(find.byKey(loadKey), findsOneWidget);

void expectRefreshWidgetIsDisplayed() =>
    expect(find.byKey(refreshKey), findsOneWidget);

void expectEmptyWidgetIsDisplayed() =>
    expect(find.byKey(emptyKey), findsOneWidget);

void expectSuccessWidgetIsDisplayed() =>
    expect(find.byKey(successKey), findsOneWidget);

void expectErrorWidgetIsDisplayed() =>
    expect(find.byKey(errorKey), findsOneWidget);
