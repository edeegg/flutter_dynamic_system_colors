import 'dart:typed_data';

import 'package:dynamic_system_colors/dynamic_system_colors.dart';
import 'package:dynamic_system_colors/src/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

/// Generates a [CorePalette] based on some generator function which takes an index.
CorePalette generateCorePalette(int Function(int index) generator) =>
    CorePalette.fromList(
      List<int>.generate(CorePalette.size * TonalPalette.commonSize, generator),
    );

/// Static methods used for testing apps with dynamic color.
class DynamicColorTestingUtils {
  /// Initializes the dynamic color plugin with mock values for testing.
  @visibleForTesting
  static void setMockDynamicColors({
    List<int>? colorSchemes,
    CorePalette? corePalette,
    Color? accentColor,
  }) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(DynamicColorPlugin.channel, (
      MethodCall methodCall,
    ) async {
      if (methodCall.method == DynamicColorPlugin.corePaletteMethodName) {
        return corePalette != null
            ? Int64List.fromList(corePalette.asList())
            : null;
      } else if (methodCall.method ==
          DynamicColorPlugin.colorSchemesMethodName) {
        return colorSchemes != null ? Int64List.fromList(colorSchemes) : null;
      } else if (methodCall.method ==
          DynamicColorPlugin.accentColorMethodName) {
        return accentColor?.bits;
      } else {
        return null;
      }
    });
    addTearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        DynamicColorPlugin.channel,
        (MethodCall methodCall) => null,
      );
    });
  }
}

final List<int> sampleColorSchemesList = List.generate(86, (i) => i + 42);
