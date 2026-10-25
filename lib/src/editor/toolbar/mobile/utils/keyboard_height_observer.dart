import 'package:appflowy_editor/src/editor/util/platform_extension.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/widgets.dart';

typedef KeyboardHeightCallback = void Function(double height);

// Tracks the system keyboard height through window view insets so the toolbar
// can mirror it without depending on a native plugin.
class KeyboardHeightObserver extends WidgetsBindingObserver {
  KeyboardHeightObserver._() {
    if (PlatformExtension.isAndroid && androidSDKVersion == -1) {
      DeviceInfoPlugin().androidInfo.then(
            (value) => androidSDKVersion = value.version.sdkInt,
          );
    }
    WidgetsBinding.instance.addObserver(this);
  }
  static int androidSDKVersion = -1;

  static final KeyboardHeightObserver instance = KeyboardHeightObserver._();
  static double currentKeyboardHeight = 0;

  final List<KeyboardHeightCallback> _listeners = [];

  @override
  void didChangeMetrics() {
    final view = WidgetsBinding.instance.platformDispatcher.implicitView;
    if (view == null) {
      return;
    }
    final height = view.viewInsets.bottom / view.devicePixelRatio;
    if (height == currentKeyboardHeight) {
      return;
    }
    currentKeyboardHeight = height;
    notify(height);
  }

  void addListener(KeyboardHeightCallback listener) {
    _listeners.add(listener);
  }

  void removeListener(KeyboardHeightCallback listener) {
    _listeners.remove(listener);
  }

  void dispose() {
    _listeners.clear();
    WidgetsBinding.instance.removeObserver(this);
  }

  void notify(double height) {
    for (final listener in _listeners) {
      listener(height);
    }
  }
}
