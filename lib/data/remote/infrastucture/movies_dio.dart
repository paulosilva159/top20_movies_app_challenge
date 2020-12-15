import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:domain/exceptions.dart';

class MoviesDio extends DioForNative {
  MoviesDio([BaseOptions options]) : super(options);

  @override
  Future<Response<T>> request<T>(
    String path, {
    dynamic data,
    Map<String, dynamic> queryParameters,
    CancelToken cancelToken,
    Options options,
    void Function(int, int) onSendProgress,
    void Function(int, int) onReceiveProgress,
  }) =>
      super
          .request(
        path,
        data: data,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        options: options,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      )
          .catchError(
        (error) {
          if (error is DioError && error.error is SocketException) {
            throw NoConnectionException();
          }

          throw error;
        },
      );
}
