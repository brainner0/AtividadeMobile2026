import 'package:flutter/material.dart';

mixin LoaderMixin<T extends StatefulWidget> on State<T> {
  bool _isLoaderOpen = false;

  void showLoader() {
    if (_isLoaderOpen) return;

    _isLoaderOpen = true;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  void hideLoader() {
    if (_isLoaderOpen && mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      _isLoaderOpen = false;
    }
  }
}
