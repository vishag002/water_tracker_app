import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/constants/colour_const.dart';

class LoaderOverlay {
  LoaderOverlay._privateConstructor();

  static final LoaderOverlay instance = LoaderOverlay._privateConstructor();

  /// Optional navigator key — set this once in your app (e.g. in main.dart or
  /// your MaterialApp) so the overlay can be shown without a BuildContext:
  ///
  ///   LoaderOverlay.instance.navigatorKey = navigatorKey;
  GlobalKey<NavigatorState>? navigatorKey;

  OverlayEntry? _entry;
  double? _currentProgress;
  String? _currentText;

  OverlayEntry _createEntry({double? progress, String? loadingText}) {
    return OverlayEntry(
      builder: (_) => Positioned.fill(
        child: LoaderCustom(progress: progress, loadingText: loadingText),
      ),
    );
  }

  void show({BuildContext? context, double? progress, String? loadingText}) {
    // If already shown and values unchanged, do nothing.
    if (_entry != null &&
        _currentProgress == progress &&
        _currentText == loadingText) {
      return;
    }

    // If shown but values changed, remove first.
    _removeInternal();

    _currentProgress = progress;
    _currentText = loadingText;
    _entry = _createEntry(progress: progress, loadingText: loadingText);

    void tryInsert(OverlayState? overlayState) {
      if (overlayState == null) return;
      try {
        overlayState.insert(_entry!);
      } catch (_) {
        // ignore insertion errors
      }
    }

    // 1) Try the supplied navigator key's overlay (most reliable).
    final overlayFromKey = navigatorKey?.currentState?.overlay;
    if (overlayFromKey != null) {
      tryInsert(overlayFromKey);
      return;
    }

    // 2) Try Overlay.of using the provided context.
    if (context != null) {
      OverlayState? overlayState;
      try {
        overlayState = Overlay.of(context, rootOverlay: true);
      } catch (_) {
        try {
          overlayState = Overlay.of(context);
        } catch (_) {
          overlayState = null;
        }
      }
      if (overlayState != null) {
        tryInsert(overlayState);
        return;
      }
    }

    // 3) Post-frame fallback — re-checks all options after the current frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        final overlayFromKey2 = navigatorKey?.currentState?.overlay;
        if (overlayFromKey2 != null) {
          tryInsert(overlayFromKey2);
          return;
        }

        if (context != null) {
          OverlayState? overlayState2;
          try {
            overlayState2 = Overlay.of(context, rootOverlay: true);
          } catch (_) {
            try {
              overlayState2 = Overlay.of(context);
            } catch (_) {
              overlayState2 = null;
            }
          }
          tryInsert(overlayState2);
        }
      } catch (_) {
        // ignore
      }
    });
  }

  void hide() {
    _removeInternal();
    _currentProgress = null;
    _currentText = null;
  }

  void _removeInternal() {
    try {
      _entry?.remove();
    } catch (_) {}
    _entry = null;
  }
}

class LoaderCustom extends StatelessWidget {
  const LoaderCustom({super.key, this.progress, this.loadingText});

  final double? progress;
  final String? loadingText;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blur the underlying screen.
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(color: Colors.transparent),
          ),
        ),

        // Dim layer above blur.
        Positioned.fill(
          child: ModalBarrier(
            color: AppColors.colour000000.withValues(alpha: 0.35),
            dismissible: false,
          ),
        ),

        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 0.25.sh),
                CircularProgressIndicator(
                  constraints: BoxConstraints(minHeight: 61.h, minWidth: 61.w),
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.colour368AE9,
                  ),
                  strokeCap: StrokeCap.round,
                ),
                SizedBox(height: 0.25.sh),
                if (progress != null)
                  LinearProgressIndicator(
                    value: progress!,
                    color: Colors.white,
                    minHeight: 14.h,
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.colour368AE9,
                    ),
                  ),
                SizedBox(height: 10.h),
                Text(
                  loadingText ?? 'Loading...',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.colour368AE9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
