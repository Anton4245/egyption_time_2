import 'package:ejyption_time_2/core/MVVW/error_handler.dart';
import 'package:flutter/material.dart';

abstract class ViewModel extends ChangeNotifier {
  final ErrorHandler _errorHandler;

  ViewModel({
    required ErrorHandler errorHandler,
  }) : _errorHandler = errorHandler;

  /// Колбек на initState
  void onInit() {
    debugPrint('init $this, hash: $hashCode, listeners: $hasListeners');
  }

  /// Колбек на dispose
  void onDispose() {
    debugPrint('dispose $this,  hash: $hashCode');
  }

  /// Безопасный вызов кода
  void safe(void Function() call, {void Function(Object)? onError}) {
    try {
      call();
    } on Object catch (e) {
      onError?.call(e);
      handleError(e);
    }
  }

  void handleError(Object e) {
    _errorHandler.handleError(e);
  }
}
