import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptiveAlertDialog extends StatelessWidget {
  const AdaptiveAlertDialog({
    @required this.title,
    @required this.message,
    @required this.actions,
  })  : assert(title != null),
        assert(message != null),
        assert(actions != null);

  final String title;
  final String message;
  final List<AdaptiveAlertDialogAction> actions;

  Future<bool> show(BuildContext context) async => Platform.isIOS
      ? showCupertinoDialog(context: context, builder: (context) => this)
      : showDialog(context: context, builder: (context) => this);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: actions,
        )
      : AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: actions,
        );
}

class AdaptiveAlertDialogAction extends StatelessWidget {
  const AdaptiveAlertDialogAction({
    @required this.title,
    @required this.isDefaultAction,
    this.onPressed,
  })  : assert(title != null),
        assert(isDefaultAction != null);

  final String title;
  final VoidCallback onPressed;
  final bool isDefaultAction;

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? CupertinoDialogAction(
          onPressed: onPressed ?? () => Navigator.of(context).pop(true),
          isDefaultAction: isDefaultAction,
          child: Text(title),
        )
      : FlatButton(
          onPressed: onPressed ?? () => Navigator.of(context).pop(true),
          child: Text(title),
        );
}
