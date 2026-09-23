import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:water_tracker_app/database/app_database.dart';
import 'package:water_tracker_app/features/home/presentation/providers/water_entry_provider.dart';

/// Same dialog shape/style as WaterGoalEditDialog. Only the amount is
/// editable — the entry's time is shown for context but is fixed.
class WaterEntryEditDialog extends ConsumerStatefulWidget {
  const WaterEntryEditDialog({super.key, required this.entry});

  final WaterEntry entry;

  static Future<void> show(BuildContext context, {required WaterEntry entry}) {
    return showDialog<void>(
      context: context,
      builder: (_) => WaterEntryEditDialog(entry: entry),
    );
  }

  @override
  ConsumerState<WaterEntryEditDialog> createState() =>
      _WaterEntryEditDialogState();
}

class _WaterEntryEditDialogState extends ConsumerState<WaterEntryEditDialog> {
  late final _controller = TextEditingController(
    text: widget.entry.amount.toString(),
  );
  bool _isSubmitting = false;
  String? _errorText;

  static final DateFormat _timeFormat = DateFormat('h:mm a');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    final parsed = int.tryParse(_controller.text.trim());
    if (parsed == null || parsed <= 0) {
      setState(() => _errorText = 'Enter a valid amount');
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorText = null;
    });

    await ref
        .read(waterEntryRepositoryProvider)
        .updateEntryAmount(widget.entry.id, parsed);

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
              'Edit water intake',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Logged at ${_timeFormat.format(widget.entry.addedAt)}',
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
                hintText: 'e.g. 250',
                suffixText: widget.entry.unit,
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
