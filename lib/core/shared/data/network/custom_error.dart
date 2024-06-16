enum CustomErrorType {
  timeout,
  notFound,
  badRequest,
  unauthorized,
  forbidden,
  conflict,
  requestEntityTooLarge,
  internalServerError,
  serviceUnavailable,
  internetConnection,
  unhandled,
  localizationError,
  notResults,
}

class CustomError implements Exception {
  final CustomErrorType? type;
  final String? message;

  CustomError({
    this.type,
    this.message,
  });

  CustomError copyWith({
    CustomErrorType? type,
    String? message,
  }) =>
      CustomError(
        type: type ?? this.type,
        message: message ?? this.message,
      );
}
