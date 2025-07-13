import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Web implementation of [createPlatformView]
class ZegoExpressPlatformViewImpl {
  /// Create a PlatformView and return the view ID
  static Widget? createPlatformView(Function(int viewID) onViewCreated,
      {Key? key}) {
    const String webcamPushElement = 'plugins.zego.im/zego_express_view';

    if (kIsWeb) {
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(webcamPushElement, (int id) {
        return DivElement()..id = "zego-view-$id";
      });
    } else {
      // Return null or an empty Container if not web
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
