import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../generated/l10n.dart';

class ErrorIndicator extends StatelessWidget {
  const ErrorIndicator({
    @required this.error,
    @required this.onTryAgainTap,
  })  : assert(error != null),
        assert(onTryAgainTap != null);

  final dynamic error;
  final VoidCallback onTryAgainTap;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            if (error is DioError)
              if (error.error is SocketException)
                Text(
                  S.of(context).connectionErrorMessage,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                )
              else
                Text(
                  S.of(context).dioErrorMessage,
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 12),
                )
            else
              Text(
                S.of(context).genericErrorMessage,
                style: const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            RaisedButton(
              onPressed: onTryAgainTap,
              child: Text(S.of(context).tryAgainMessage),
            ),
          ],
        ),
      );
}
