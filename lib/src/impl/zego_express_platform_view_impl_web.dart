import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:html';
import 'dart:ui' as ui;

/// Web implementation of [createPlatformView]
class ZegoExpressPlatformViewImpl {
  /// Create a PlatformView and return the view ID
  static Widget? createPlatformView(Function(int viewID) onViewCreated,
      {Key? key}) {
    String webcamPushElement = 'plugins.zego.im/zego_express_view';

    // Register a view factory for web
    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(webcamPushElement, (int id) {
      return DivElement()..id = "zego-view-$id";
    });

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
