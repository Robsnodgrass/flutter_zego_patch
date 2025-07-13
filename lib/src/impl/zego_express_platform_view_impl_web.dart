import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:html';
import 'package:js/js.dart';

@JS('window.flutterWeb.platformViewRegistry')
external PlatformViewRegistry get platformViewRegistry;

@JS()
@anonymous
class PlatformViewRegistry {
  external void registerViewFactory(String viewTypeId, Function viewFactory);
}

class ZegoExpressPlatformViewImpl {
  static Widget? createPlatformView(Function(int viewID) onViewCreated, {Key? key}) {
    const String webcamPushElement = 'plugins.zego.im/zego_express_view';

    platformViewRegistry.registerViewFactory(webcamPushElement, allowInterop((int id) {
      return DivElement()..id = "zego-view-$id";
    }));

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
