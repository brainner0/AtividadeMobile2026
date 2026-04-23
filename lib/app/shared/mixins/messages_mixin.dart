import 'package:flutter/material.dart';

mixin MessagesMixin<T extends StatefulWidget> on State<T> {
  void showSuccess(String message) => _showSnack(message, Theme.of(context).colorScheme.primary);

  void showError(String message) => _showSnack(message, Theme.of(context).colorScheme.error);

  void _showSnack(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
