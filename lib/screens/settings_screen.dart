import 'package:flutter/material.dart';
import 'package:water_tracker_app/components/scaffold_custom.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      title: 'settings',
      centerTitle: true,
      body: Column(children: [
        Text("Mode",style: AppTextStyles.bodyRegular,)]),
    );
  }
}
