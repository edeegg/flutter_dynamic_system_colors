import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:dynamic_system_colors/samples.dart';
import 'package:dynamic_system_colors/test_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    DynamicColorTestingUtils.setMockDynamicColors(
      corePalette: SampleCorePalettes.green,
      accentColor: Colors.amber,
    );
  });

  const containerKey = Key('myContainer');

  Widget dynamicColorBuilder() => DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          return Container(
            key: containerKey,
            color: lightDynamic?.primary ?? const Color(0x00000123),
          );
        },
      );

  testWidgets('DynamicColorBuilder is correct on Android',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors(
      corePalette: SampleCorePalettes.green,
    );

    await tester.pumpWidget(dynamicColorBuilder());
    await tester.pumpAndSettle();

    final container = tester.firstWidget(find.byKey(containerKey)) as Container;
    expect(container.color, const Color(0xff286c2a));
  });

  testWidgets('DynamicColorBuilder is correct on Android with colorSchemes',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors(
      colorSchemes: sampleColorSchemesList,
      corePalette: SampleCorePalettes.green,
    );

    await tester.pumpWidget(dynamicColorBuilder());
    await tester.pumpAndSettle();

    final container = tester.firstWidget(find.byKey(containerKey)) as Container;
    expect(container.color, const Color(0x0000002a));
  });

  testWidgets('DynamicColorBuilder is correct on desktop',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors(
      accentColor: Colors.amber,
    );
    await tester.pumpWidget(dynamicColorBuilder());
    await tester.pumpAndSettle();

    final container = tester.firstWidget(find.byKey(containerKey)) as Container;
    expect(container.color, const Color(0xff775a0b));
  });

  testWidgets('DynamicColorBuilder is correct on other platforms',
      (WidgetTester tester) async {
    DynamicColorTestingUtils.setMockDynamicColors();

    await tester.pumpWidget(dynamicColorBuilder());
    await tester.pumpAndSettle();

    final container = tester.firstWidget(find.byKey(containerKey)) as Container;
    expect(container.color, const Color(0x00000123));
  });
}
