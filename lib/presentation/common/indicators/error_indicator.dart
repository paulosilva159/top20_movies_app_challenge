import 'package:dio/dio.dart';
import 'package:domain/exceptions.dart';
import 'package:flutter/material.dart';

import 'package:tokenlab_challenge/generated/l10n.dart';
import 'package:tokenlab_challenge/presentation/common/generic_error.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    @required this.type,
    @required this.onTryAgainTap,
  })  : assert(type != null),
        assert(onTryAgainTap != null);

  final GenericErrorType type;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            if (type is NoConnectionException)
              Text(
                S.of(context).connectionErrorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              )
            else
              Text(
                S.of(context).genericErrorMessage,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            RaisedButton(
              onPressed: onTryAgainTap,
              child: Text(
                S.of(context).tryAgainMessage,
              ),
            ),
          ],
        ),
      );
}
