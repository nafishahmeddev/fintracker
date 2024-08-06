import 'package:flutter/material.dart';

class LoadingModal extends StatelessWidget{
  final Widget content;
  const LoadingModal({
    super.key,
    required this.content,
  });
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: const EdgeInsets.all(20),
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 20,),
          Expanded(child: content)
        ],
      )
    );
  }

  static showLoadingDialog(BuildContext context, {
    required Widget content,
  }){
    showDialog(context: context,
        builder: (BuildContext context){
          return LoadingModal(content: content);
        }
    );
  }

}