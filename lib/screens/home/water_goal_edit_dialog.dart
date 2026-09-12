import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../providers/water_goal_provider.dart';

/// Same dialog shape/style as OnboardingNameDialog, adapted for a numeric
/// litre value instead of a name. Only "L" is supported for now — the
/// unit field exists in the schema for later, but there's no picker yet.
class WaterGoalEditDialog extends ConsumerStatefulWidget {
  const WaterGoalEditDialog({
    super.key,
    required this.userId,
    required this.currentGoal,
  });

  final int userId;
  final int currentGoal;

  static Future<void> show(
    BuildContext context, {
    required int userId,
    required int currentGoal,
  }) {
    return showDialog<void>(
      context: context,
      builder: (_) =>
          WaterGoalEditDialog(userId: userId, currentGoal: currentGoal),
    );
  }

  @override
  ConsumerState<WaterGoalEditDialog> createState() =>
      _WaterGoalEditDialogState();
}

class _WaterGoalEditDialogState extends ConsumerState<WaterGoalEditDialog> {
  late final _controller = TextEditingController(
    text: widget.currentGoal.toString(),
  );
  bool _isSubmitting = false;
  String? _errorText;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final parsed = int.tryParse(_controller.text.trim());
    if (parsed == null || parsed <= 0) {
      setState(() => _errorText = 'Enter a valid number of litres');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    await ref.read(waterGoalRepositoryProvider).createWaterGoal(
      userId: widget.userId,
      goal: parsed,
      unit: 'L',
    );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Set your daily goal',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'How many litres of water do you want to drink each day?',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                hintText: 'e.g. 2',
                suffixText: 'L',
                errorText: _errorText,
                filled: true,
                fillColor: theme.colorScheme.surfaceContainerHighest,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 14.h,
                ),
              ),
              onSubmitted: (_) => _submit(),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child: _isSubmitting
                    ? SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}