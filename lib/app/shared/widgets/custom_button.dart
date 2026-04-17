import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool expanded;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: expanded ? double.infinity : null,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
