import 'package:flutter/material.dart';

class errorDialog extends StatelessWidget {
  final String message;

  errorDialog({required this.message});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss the dialog
    });

    return SimpleDialog(
      shadowColor: Colors.red,
      // insetPadding: EdgeInsets.only(bottom: 100),
      children: [
        Row(
          children: [
            SizedBox(width: 5),
            Icon(Icons.error),
            SizedBox(width: 5),
            Container(
              child: Text(
                message,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Future<void> showerrorDialoge(String message, BuildContext context) async {
  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return errorDialog(message: message);
    },
  );
}
