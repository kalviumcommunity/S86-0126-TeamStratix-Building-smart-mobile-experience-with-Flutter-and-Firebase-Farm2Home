import 'package:flutter/material.dart';
import '../core/app_breakpoints.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color? confirmColor;
  final IconData? icon;
  final bool isDangerous;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.confirmColor,
    this.icon,
    this.isDangerous = false,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: isDangerous ? Colors.red : Theme.of(context).primaryColor,
            ),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
            onCancel?.call();
          },
          child: Text(cancelText),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            onConfirm?.call();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ??
                (isDangerous ? Colors.red : Theme.of(context).primaryColor),
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }

  static Future<bool> show(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
    IconData? icon,
    bool isDangerous = false,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        confirmColor: confirmColor,
        icon: icon,
        isDangerous: isDangerous,
      ),
    );
    
    return result ?? false;
  }
}

class DeleteConfirmationDialog extends StatelessWidget {
  final String itemName;
  final VoidCallback? onConfirm;

  const DeleteConfirmationDialog({
    super.key,
    required this.itemName,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return ConfirmationDialog(
      title: 'Delete $itemName?',
      message: 'Are you sure you want to delete this $itemName? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_forever,
      isDangerous: true,
      onConfirm: onConfirm,
    );
  }

  static Future<bool> show(
    BuildContext context,
    String itemName,
  ) async {
    return ConfirmationDialog.show(
      context,
      title: 'Delete $itemName?',
      message: 'Are you sure you want to delete this $itemName? This action cannot be undone.',
      confirmText: 'Delete',
      cancelText: 'Cancel',
      icon: Icons.delete_forever,
      isDangerous: true,
    );
  }
}

class InfoDialog extends StatelessWidget {
  final String title;
  final String message;
  final String buttonText;
  final IconData? icon;

  const InfoDialog({
    super.key,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Theme.of(context).primaryColor),
            const SizedBox(width: AppSpacing.md),
          ],
          Expanded(child: Text(title)),
        ],
      ),
      content: Text(message),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(buttonText),
        ),
      ],
    );
  }

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
    IconData? icon,
  }) async {
    await showDialog(
      context: context,
      builder: (context) => InfoDialog(
        title: title,
        message: message,
        buttonText: buttonText,
        icon: icon,
      ),
    );
  }
}
