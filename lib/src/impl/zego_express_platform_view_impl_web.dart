import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:html';

// ignore: undefined_prefixed_name
@pragma('vm:entry-point')
external dynamic get platformViewRegistry;

class ZegoExpressPlatformViewImpl {
  static Widget? createPlatformView(Function(int viewID) onViewCreated, {Key? key}) {
    const String webcamPushElement = 'plugins.zego.im/zego_express_view';

    // ignore: undefined_prefixed_name
    // Use the JS interop to call the platformViewRegistry
    // The ignore is needed because it's not defined in Dart normally
    platformViewRegistry.registerViewFactory(webcamPushElement, (int id) {
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
