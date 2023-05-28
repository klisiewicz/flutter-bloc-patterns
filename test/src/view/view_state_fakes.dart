import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

class BuildContextFake extends Fake implements BuildContext {}

void registerBuildContextFallbackValue() {
  registerFallbackValue(BuildContextFake());
}
