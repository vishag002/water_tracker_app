import 'package:flutter/material.dart';
import 'package:water_tracker_app/components/custom_loader.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class ScaffoldCustom extends StatelessWidget {
  const ScaffoldCustom({
    super.key,
    this.backgroundColor,
    required this.body,
    this.title,
    this.appBarActions,
    this.leading,
    this.isLoading = false,
    this.progress,
    this.loadingText,
    this.showAppBar = true,
    this.floatingActionButton,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset,
    this.appBarBackgroundColor,
    this.titleStyle,
    this.centerTitle = false,
    this.appBarBottom,
    this.extendBodyBehindAppBar = false,
    this.safeArea = true,
  });

  // Scaffold
  final Color? backgroundColor;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;
  final bool? resizeToAvoidBottomInset;
  final bool extendBodyBehindAppBar;
  final bool safeArea;

  // Loading
  final bool isLoading;
  final double? progress;
  final String? loadingText;

  // AppBar
  final bool showAppBar;
  final String? title;
  final TextStyle? titleStyle;
  final bool centerTitle;
  final List<Widget>? appBarActions;
  final Widget? leading;
  final Color? appBarBackgroundColor;
  final PreferredSizeWidget? appBarBottom;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isLoading) {
        LoaderOverlay.instance.show(
          context: context,
          progress: progress,
          loadingText: loadingText,
        );
      } else {
        LoaderOverlay.instance.hide();
      }
    });

    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: backgroundColor ?? theme.scaffoldBackgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: showAppBar
          ? AppBar(
              scrolledUnderElevation: 0.0,
              leading: leading,
              iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
              centerTitle: centerTitle,
              backgroundColor:
                  appBarBackgroundColor ?? theme.scaffoldBackgroundColor,
              actions: appBarActions != null
                  ? [...appBarActions!, const SizedBox(width: 12)]
                  : null,
              title: title != null
                  ? Text(
                      title!,
                      style:
                          titleStyle ??
                          AppTextStyles.subtitleSemiBold.copyWith(
                            color: theme.colorScheme.onSurface,
                          ),
                    )
                  : null,
              bottom: appBarBottom,
            )
          : null,
      body: safeArea ? SafeArea(child: body) : body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
