import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:html';

// Import platformViewRegistry explicitly for Flutter Web
// ignore: uri_does_not_exist
import 'dart:ui' 
    if (dart.library.html) 'dart:ui_web.dart' 
    as ui;

import 'package:flutter/foundation.dart' show kIsWeb;

/// Web implementation of [createPlatformView]
class ZegoExpressPlatformViewImpl {
  /// Create a PlatformView and return the view ID
  static Widget? createPlatformView(Function(int viewID) onViewCreated,
      {Key? key}) {
    const String webcamPushElement = 'plugins.zego.im/zego_express_view';

    if (kIsWeb) {
      // Register the view factory via ui.platformViewRegistry
      ui.platformViewRegistry.registerViewFactory(webcamPushElement, (int id) {
        return DivElement()..id = "zego-view-$id";
      });
    } else {
      return null;
    }

    return HtmlElementView(
      key: key,
      viewType: webcamPushElement,
      onPlatformViewCreated: (int viewID) {
        const checkInterval = Duration(milliseconds: 10);
        const maxChecks = 150;
        int checks = 0;
        final elementId = "zego-view-$viewID";

        Timer.periodic(checkInterval, (timer) {
          final div = window.document.getElementById(elementId);
          if (div != null || checks >= maxChecks) {
            timer.cancel();
            onViewCreated(viewID);
          }
          checks++;
        });
      },
    );
  }
}
