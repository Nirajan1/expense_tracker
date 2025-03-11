import 'package:flutter/material.dart';

class AppSnackBar {
  static void showCustomSnackBar(
    BuildContext context,
    String message,
    bool isError, {
    bool isTop = false,
  }) {
    // Create an OverlayEntry
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: isTop ? MediaQuery.of(context).padding.top : null,
        bottom: isTop ? null : 0,
        left: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: isError ? Colors.red : Colors.green, // Customize color
            child: Text(
              message,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    // Insert the overlay into the Overlay
    Overlay.of(context).insert(overlayEntry);

    // Remove the overlay after a delay
    Future.delayed(
      const Duration(seconds: 2),
      () {
        overlayEntry.remove();
      },
    );
  }
}
