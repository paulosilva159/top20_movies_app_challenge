import 'package:flutter/cupertino.dart';
import 'package:tokenlab_challenge/generated/l10n.dart';
import 'package:tokenlab_challenge/presentation/common/alert_dialogs/adaptive_alert_dialog.dart';

void showToogleFavoriteErrorDialog(BuildContext context) =>
    AdaptiveAlertDialog(
      title: S.of(context).alertDialogErrorTitle,
      message: S.of(context).alertDialogErrorMessage,
      actions: [
        AdaptiveAlertDialogAction(
          title: S.of(context).alertDialogActionTitle,
          isDefaultAction: true,
        )
      ],
    ).show(context);

void showToogleFavoriteSuccessDialog(
        BuildContext context, String title, bool isToFavorite) =>
    AdaptiveAlertDialog(
      title: S.of(context).alertDialogSuccessTitle,
      message: isToFavorite
          ? S.of(context).alertDialogToFavoriteSuccessMessage(title)
          : S.of(context).alertDialogToUnfavoriteSuccessMessage(title),
      actions: [
        AdaptiveAlertDialogAction(
          title: S.of(context).alertDialogActionTitle,
          isDefaultAction: true,
        )
      ],
    ).show(context);
