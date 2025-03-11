import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.2),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6, // Adjust size as needed
          height: MediaQuery.of(context).size.width * 0.4, // Adjust size as needed
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                SelectableText(
                  'Loading...',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  enableInteractiveSelection: false,
                ) // Spacing between indicator and text
              ],
            ), // Loading indicator
          ),
        ),
      ),
    );
  }
}

void showLoadingOverlay(BuildContext context) {
  // Create an OverlayEntry
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => const LoadingOverlay(),
  );

  // Insert the overlay into the Overlay
  Overlay.of(context).insert(overlayEntry);

  // Store the overlay entry in the context for later removal
  context.loadingOverlayEntry = overlayEntry;
}

void hideLoadingOverlay(BuildContext context) {
  // Remove the overlay entry from the context
  if (context.loadingOverlayEntry != null) {
    context.loadingOverlayEntry!.remove();
    context.loadingOverlayEntry = null;
  }
}

extension OverlayExtension on BuildContext {
  static final Map<BuildContext, OverlayEntry> _overlayEntries = {};

  OverlayEntry? get loadingOverlayEntry => _overlayEntries[this];

  set loadingOverlayEntry(OverlayEntry? entry) {
    if (entry == null) {
      _overlayEntries.remove(this);
    } else {
      _overlayEntries[this] = entry;
    }
  }
}
