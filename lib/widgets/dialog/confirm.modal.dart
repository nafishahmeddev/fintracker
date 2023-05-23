import 'package:fintracker/theme/colors.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:flutter/material.dart';

class ConfirmModal extends StatelessWidget{
  final String title;
  final Widget content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  const ConfirmModal({
    super.key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600),),
      insetPadding: const EdgeInsets.all(20),
      content: content,
      actions: [
        Row(
          children: [
            Expanded(
                child: AppButton(
                    label: "No",
                    onPressed: onCancel,
                    color: Theme.of(context).colorScheme.primary,
                    type: AppButtonType.outlined
                )
            ),
            const SizedBox(width: 15,),
            Expanded(
                child: AppButton(
                  label: "Yes",
                  onPressed: onConfirm,
                  color: ThemeColors.error,
                )
            ),
          ],
        )
      ],
    );
  }

  static showConfirmDialog(BuildContext context, {
    required String title,
    required Widget content,
    required VoidCallback onConfirm,
    required VoidCallback onCancel
  }
  ){
    showDialog(context: context, builder: (BuildContext context){
      return ConfirmModal(title: title, content: content, onConfirm: onConfirm, onCancel: onCancel);
    });
  }

}