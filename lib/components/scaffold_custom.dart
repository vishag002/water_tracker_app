// import 'package:flutter/material.dart';
// import 'package:water_tracker_app/helpers/colour_const.dart';

// class ScaffoldCustom extends StatelessWidget {
//   const ScaffoldCustom({
//     super.key,
//     this.backgroundColor,
//     required this.body,
//     this.title,
//     this.appBarActions,
//     this.leading,
//     this.isLoading = false,
//     this.progress,
//     this.loadingText,
//     this.showAppBar = true,
//     this.floatingActionButton,
//     this.bottomNavigationBar,
//     this.resizeToAvoidBottomInset,
//     this.appBarBackgroundColor,
//     this.titleStyle,
//     this.centerTitle = false,
//     this.appBarBottom,
//     this.extendBodyBehindAppBar = false,
//     this.safeArea = true,
//   });

//   // Scaffold
//   final Color? backgroundColor;
//   final Widget body;
//   final Widget? floatingActionButton;
//   final Widget? bottomNavigationBar;
//   final bool? resizeToAvoidBottomInset;
//   final bool extendBodyBehindAppBar;
//   final bool safeArea;

//   // Loading
//   final bool isLoading;
//   final double? progress;
//   final String? loadingText;

//   // AppBar
//   final bool showAppBar;
//   final String? title;
//   final TextStyle? titleStyle;
//   final bool centerTitle;
//   final List<Widget>? appBarActions;
//   final Widget? leading;
//   final Color? appBarBackgroundColor;
//   final PreferredSizeWidget? appBarBottom;

//   @override
//   Widget build(BuildContext context) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       if (isLoading) {
//         LoaderOverlay.instance.show(
//           context: context,
//           progress: progress,
//           loadingText: loadingText,
//         );
//       } else {
//         LoaderOverlay.instance.hide();
//       }
//     });

//     return Scaffold(
//       backgroundColor: backgroundColor ?? AppColors.colourFFFFFF,
//       resizeToAvoidBottomInset: resizeToAvoidBottomInset,
//       extendBodyBehindAppBar: extendBodyBehindAppBar,
//       appBar: showAppBar
//           ? AppBar(
//               scrolledUnderElevation: 0.0,
//               leading: leading,
//               iconTheme: const IconThemeData(color: AppColors.colour000000),
//               centerTitle: centerTitle,
//               backgroundColor: appBarBackgroundColor ?? AppColors.colourFFFFFF,
//               actions: appBarActions != null
//                   ? [...appBarActions!, SizedBox(width: 12.w)]
//                   : null,
//               title: title != null
//                   ? Text(
//                       title!,
//                       style:
//                           titleStyle ??
//                           Get.textTheme.displaySmall!.copyWith(
//                             color: AppColors.colourFFFFFF,
//                           ),
//                     )
//                   : null,
//               bottom: appBarBottom,
//             )
//           : null,
//       body: safeArea ? SafeArea(child: body) : body,
//       floatingActionButton: floatingActionButton,
//       bottomNavigationBar: bottomNavigationBar,
//     );
//   }
// }