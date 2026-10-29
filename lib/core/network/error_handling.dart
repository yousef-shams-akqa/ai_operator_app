import 'package:dio/dio.dart' show DioException, DioExceptionType;

class ErrorHandler {
  static ErrorResponse handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ErrorResponseType.connectionTimeout.errorResponse;
      case DioExceptionType.receiveTimeout:
        return ErrorResponseType.receiveTimeout.errorResponse;
      case DioExceptionType.sendTimeout:
        return ErrorResponseType.sendTimeout.errorResponse;
      case DioExceptionType.cancel:
        return ErrorResponseType.cancel.errorResponse;
      case DioExceptionType.connectionError:
        return ErrorResponseType.connectionError.errorResponse;
      case DioExceptionType.badCertificate:
        return ErrorResponseType.badCertificate.errorResponse;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final message = error.response?.data['message'];
        switch (statusCode) {
          case ErrorResponseCode.badRequest:
            return ErrorResponseType.badRequest.errorResponse.copyWith(message: message);
          case ErrorResponseCode.unauthorized:
            return ErrorResponseType.unauthorized.errorResponse.copyWith(message: message);
          case ErrorResponseCode.forbidden:
            return ErrorResponseType.forbidden.errorResponse.copyWith(message: message);
          case ErrorResponseCode.notFound:
            return ErrorResponseType.notFound.errorResponse.copyWith(message: message);
          case ErrorResponseCode.methodNotAllowed:
            return ErrorResponseType.methodNotAllowed.errorResponse.copyWith(message: message);
          case ErrorResponseCode.tooManyRequests:
            return ErrorResponseType.tooManyRequests.errorResponse.copyWith(message: message);
          case ErrorResponseCode.internalServerError:
            return ErrorResponseType.internalServerError.errorResponse.copyWith(message: message);
          case ErrorResponseCode.badGateway:
            return ErrorResponseType.badGateway.errorResponse.copyWith(message: message);
          case ErrorResponseCode.serviceUnavailable:
            return ErrorResponseType.serviceUnavailable.errorResponse.copyWith(message: message);
          case ErrorResponseCode.gatewayTimeout:
            return ErrorResponseType.gatewayTimeout.errorResponse.copyWith(message: message);
          case ErrorResponseCode.badCertificate:
            return ErrorResponseType.badCertificate.errorResponse.copyWith(message: message);
          case ErrorResponseCode.unknown:
            return ErrorResponseType.unknown.errorResponse.copyWith(message: message);
          default:
            return ErrorResponseType.unknown.errorResponse.copyWith(message: message);
        }

      case DioExceptionType.unknown:
        return ErrorResponseType.unknown.errorResponse;
      default:
        return ErrorResponseType.unknown.errorResponse;
    }
  }
}




class ErrorResponse extends Error {
  final String message;
  final int code;

  ErrorResponse({ required this.message, required this.code });

  @override
  String toString() {
    return 'ErrorResponse: $message (Code: $code)';
  }

  ErrorResponse copyWith({ String? message, int? code }) {
    return ErrorResponse(message: message ?? this.message, code: code ?? this.code);
  }
}


enum ErrorResponseType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  methodNotAllowed,
  tooManyRequests,
  internalServerError,
  badGateway,
  serviceUnavailable,
  gatewayTimeout,
  badCertificate,
  connectionTimeout,
  receiveTimeout,
  sendTimeout,
  cancel,
  connectionError,
  unknown,
}


extension ErrorResponseTypeExtension on ErrorResponseType {
   ErrorResponse get errorResponse {
     switch (this) {
      case ErrorResponseType.badRequest:
        return ErrorResponse(message: ErrorResponseMessage.badRequest, code: ErrorResponseCode.badRequest);
      case ErrorResponseType.unauthorized:
        return ErrorResponse(message: ErrorResponseMessage.unauthorized, code: ErrorResponseCode.unauthorized);
      case ErrorResponseType.forbidden:
        return ErrorResponse(message: ErrorResponseMessage.forbidden, code: ErrorResponseCode.forbidden);
      case ErrorResponseType.notFound:
        return ErrorResponse(message: ErrorResponseMessage.notFound, code: ErrorResponseCode.notFound);
      case ErrorResponseType.methodNotAllowed:
        return ErrorResponse(message: ErrorResponseMessage.methodNotAllowed, code: ErrorResponseCode.methodNotAllowed);
      case ErrorResponseType.tooManyRequests:
        return ErrorResponse(message: ErrorResponseMessage.tooManyRequests, code: ErrorResponseCode.tooManyRequests);
      case ErrorResponseType.internalServerError:
        return ErrorResponse(message: ErrorResponseMessage.internalServerError, code: ErrorResponseCode.internalServerError);
      case ErrorResponseType.badGateway:
        return ErrorResponse(message: ErrorResponseMessage.badGateway, code: ErrorResponseCode.badGateway);
      case ErrorResponseType.serviceUnavailable:
        return ErrorResponse(message: ErrorResponseMessage.serviceUnavailable, code: ErrorResponseCode.serviceUnavailable);
      case ErrorResponseType.gatewayTimeout:
        return ErrorResponse(message: ErrorResponseMessage.gatewayTimeout, code: ErrorResponseCode.gatewayTimeout);
      case ErrorResponseType.connectionTimeout:
        return ErrorResponse(message: ErrorResponseMessage.connectionTimeout, code: ErrorResponseCode.unknown);
      case ErrorResponseType.receiveTimeout:
        return ErrorResponse(message: ErrorResponseMessage.receiveTimeout, code: ErrorResponseCode.unknown);
      case ErrorResponseType.sendTimeout:
        return ErrorResponse(message: ErrorResponseMessage.sendTimeout, code: ErrorResponseCode.unknown);
      case ErrorResponseType.cancel:
        return ErrorResponse(message: ErrorResponseMessage.cancel, code: ErrorResponseCode.unknown);
      case ErrorResponseType.connectionError:
        return ErrorResponse(message: ErrorResponseMessage.connectionError, code: ErrorResponseCode.unknown);
      case ErrorResponseType.badCertificate:
        return ErrorResponse(message: ErrorResponseMessage.badCertificate, code: ErrorResponseCode.badCertificate);
      case ErrorResponseType.unknown:
        return ErrorResponse(message: ErrorResponseMessage.unknown, code: ErrorResponseCode.unknown);
   }}
}



class ErrorResponseCode {
  static const int badRequest = 400;
  static const int unauthorized = 401;
  static const int forbidden = 403;
  static const int notFound = 404;
  static const int methodNotAllowed = 405;
  static const int tooManyRequests = 429;
  static const int badCertificate = 495;
  static const int internalServerError = 500;
  static const int badGateway = 502;
  static const int serviceUnavailable = 503;
  static const int gatewayTimeout = 504;
  static const int unknown = 0;
}


class ErrorResponseMessage {
  static const String badRequest = 'Bad Request';
  static const String unauthorized = 'Unauthorized';
  static const String forbidden = 'Forbidden';
  static const String notFound = 'Not Found';
  static const String methodNotAllowed = 'Method Not Allowed';
  static const String tooManyRequests = 'Too Many Requests';
  static const String badCertificate = 'Bad Certificate';
  static const String internalServerError = 'Internal Server Error';
  static const String badGateway = 'Bad Gateway';
  static const String serviceUnavailable = 'Service Unavailable';
  static const String gatewayTimeout = 'Gateway Timeout';
  static const String connectionTimeout = 'Connection Timeout';
  static const String receiveTimeout = 'Receive Timeout';
  static const String sendTimeout = 'Send Timeout';
  static const String cancel = 'Cancel';
  static const String connectionError = 'Connection Error';
  static const String unknown = 'Unknown';
}