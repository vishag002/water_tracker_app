import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:water_tracker_app/core/app_text_styles.dart';
import 'package:water_tracker_app/features/water_calculator/presentation/widgets/section_header.dart';

/// Weight entry as a stepper (-/value/+) instead of a free-text field,
/// matching the approved design. The value box itself is also directly
/// editable — tapping it focuses a borderless [TextField] (numeric
/// keyboard, no underline/highlight) so the user can type an exact
/// weight instead of only stepping by 1kg.
class WeightStepperCard extends StatefulWidget {
  const WeightStepperCard({
    super.key,
    required this.weightKg,
    required this.canDecrement,
    required this.canIncrement,
    required this.onDecrement,
    required this.onIncrement,
    required this.onWeightChanged,
  });

  final double weightKg;
  final bool canDecrement;
  final bool canIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final ValueChanged<double> onWeightChanged;

  @override
  State<WeightStepperCard> createState() => _WeightStepperCardState();
}

class _WeightStepperCardState extends State<WeightStepperCard> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.weightKg.toStringAsFixed(0),
  );
  late final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(covariant WeightStepperCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Keep the field in sync with external changes (the +/- buttons,
    // or a clamp applied upstream) — but only while the user isn't
    // actively typing, so we never fight their input mid-edit.
    if (!_focusNode.hasFocus && oldWidget.weightKg != widget.weightKg) {
      _controller.text = widget.weightKg.toStringAsFixed(0);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _commit();
    }
  }

  void _commit() {
    final parsed = double.tryParse(_controller.text);
    if (parsed == null) {
      // Empty/invalid input — revert to the last known-good value
      // rather than sending garbage upstream.
      _controller.text = widget.weightKg.toStringAsFixed(0);
      return;
    }
    // Clamping to 30–250kg happens in the notifier, same as the
    // stepper buttons — this just forwards the raw typed value.
    widget.onWeightChanged(parsed);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionHeader(
            icon: Icons.monitor_weight_outlined,
            title: 'Your weight',
            subtitle: 'Enter your body weight',
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _StepButton(
                icon: Icons.remove,
                onTap: widget.canDecrement ? widget.onDecrement : null,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _focusNode.requestFocus(),
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _focusNode.unfocus(),
                      style: AppTextStyles.subtitleSemiBold.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                      decoration: const InputDecoration.collapsed(hintText: ''),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              _StepButton(
                icon: Icons.add,
                onTap: widget.canIncrement ? widget.onIncrement : null,
              ),
              SizedBox(width: 12.w),
              Text(
                'kg',
                style: AppTextStyles.bodyRegular.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onTap != null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 40.w,
        height: 40.w,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Icon(
          icon,
          size: 18.sp,
          color: enabled
              ? theme.colorScheme.onSurface
              : theme.colorScheme.onSurface.withOpacity(0.3),
        ),
      ),
    );
  }
}
