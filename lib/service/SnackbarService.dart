import 'package:flutter/material.dart';

class Snackbarservice {
  showSnackbar(String message, BuildContext context, {bool error = false}) {
    final snackbar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'fermer',
        onPressed: () {},
        backgroundColor: error ? Colors.redAccent : null,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
