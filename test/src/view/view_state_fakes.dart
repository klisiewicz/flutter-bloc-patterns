import 'package:flutter/widgets.dart';
import 'package:flutter_bloc_patterns/src/view/view_state.dart';
import 'package:mocktail/mocktail.dart';

// ignore: avoid_implementing_value_types
class ViewStateFake extends Fake implements ViewState {}

class BuildContextFake extends Fake implements BuildContext {}

void registerVieStateFallbackValue() {
  registerFallbackValue<ViewState>(ViewStateFake());
}

void registerBuildContextFallbackValue() {
  registerFallbackValue<BuildContext>(BuildContextFake());
}
