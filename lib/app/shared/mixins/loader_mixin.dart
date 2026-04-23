import 'package:flutter/material.dart';

mixin LoaderMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _loaderEntry;

  void showLoader() {
    if (_loaderEntry != null) return;

    final overlay = Overlay.of(context);
    if (overlay == null) return;

    _loaderEntry = OverlayEntry(
      builder: (context) => Stack(
        children: const [
          ModalBarrier(color: Colors.black45, dismissible: false),
          Center(child: CircularProgressIndicator()),
        ],
      ),
    );

    overlay.insert(_loaderEntry!);
  }

  void hideLoader() {
    _loaderEntry?.remove();
    _loaderEntry = null;
  }
}
