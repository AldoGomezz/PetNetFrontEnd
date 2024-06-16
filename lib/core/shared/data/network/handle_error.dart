import 'dart:io';
import 'package:dio/dio.dart';

import 'network.dart';

CustomError handleError(dynamic e) {
  if (e is DioException) {
    if (e.response != null) {
      switch (e.response?.statusCode) {
        case 400:
          final errorMessage = e.response?.data["message"];
          return CustomError(
            type: CustomErrorType.badRequest,
            message: errorMessage,
          );
        case 401:
          final errorMessage = e.response?.data["message"];
          return CustomError(
            type: CustomErrorType.unauthorized,
            message: errorMessage,
          );
        case 403:
          final errorMessage = e.response?.data["message"];
          return CustomError(
            type: CustomErrorType.forbidden,
            message: errorMessage,
          );
        case 404:
          final errorMessage = e.response?.data["message"];
          return CustomError(
            type: CustomErrorType.notFound,
            message: errorMessage,
          );
        case 409:
          final errorMessage = e.response?.data["message"];
          return CustomError(
            type: CustomErrorType.conflict,
            message: errorMessage,
          );
        case 413:
          final errorMessage = e.response?.data["message"];
          return CustomError(
            type: CustomErrorType.requestEntityTooLarge,
            message: errorMessage,
          );
        case 500:
          final errorMessage = e.response?.data["message"];
          return CustomError(
            type: CustomErrorType.internalServerError,
            message: errorMessage,
          );
        case 503:
          final errorMessage = e.response?.data["message"];
          return CustomError(
            type: CustomErrorType.serviceUnavailable,
            message: errorMessage,
          );
        default:
          break;
      }
    }

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return CustomError(
          type: CustomErrorType.timeout,
        );
      case DioExceptionType.connectionError:
        return CustomError(
          type: CustomErrorType.internetConnection,
        );
      case DioExceptionType.badResponse:
        return CustomError(
          type: CustomErrorType.badRequest,
        );
      default:
        break;
    }

    switch (e.error) {
      case SocketException _:
        return CustomError(
          type: CustomErrorType.internetConnection,
        );
      case HandshakeException _:
        return CustomError(
          type: CustomErrorType.internetConnection,
        );
      case HttpException _:
        return CustomError(
          type: CustomErrorType.internetConnection,
        );
      default:
        break;
    }
  }

  return CustomError(
    type: CustomErrorType.unhandled,
  );
}
