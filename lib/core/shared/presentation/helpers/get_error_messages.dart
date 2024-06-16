import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pet_net_app/core/core.dart';

String getErrorMessage(CustomError error, BuildContext context) {
  final l10n = AppLocalizations.of(context)!;
  switch (error.type) {
    case CustomErrorType.unhandled:
      return l10n.error_unhandled;
    case CustomErrorType.badRequest:
      return l10n.error_bad_request;
    case CustomErrorType.conflict:
      return l10n.error_conflict;
    case CustomErrorType.forbidden:
      return l10n.error_forbidden;
    case CustomErrorType.internalServerError:
      return l10n.error_internal_server;
    case CustomErrorType.internetConnection:
      return l10n.error_internet;
    case CustomErrorType.localizationError:
      return l10n.error_localization;
    case CustomErrorType.notFound:
      return l10n.error_not_found;
    case CustomErrorType.requestEntityTooLarge:
      return l10n.error_request_entity_too_large;
    case CustomErrorType.serviceUnavailable:
      return l10n.error_service_unavailable;
    case CustomErrorType.timeout:
      return l10n.error_timeout;
    case CustomErrorType.unauthorized:
      return l10n.error_unauthorized;
    case CustomErrorType.notResults:
      return l10n.error_not_results;
    default:
      return "";
  }
}
