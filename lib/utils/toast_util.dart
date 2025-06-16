import 'dart:async';

import 'package:flutter/material.dart';
import 'package:picacg/language/generated/l10n.dart';
import 'package:picacg/rust/api/error/custom_error.dart';

class ToastUtil {
  static void showErrorSnackBar({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      message: message,
      context: context,
      duration: duration,
      textColor: Theme.of(context).colorScheme.onError,
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }

  static void showInfoSnackBar({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      message: message,
      context: context,
      duration: duration,
      textColor: Theme.of(context).colorScheme.onPrimaryContainer,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  static void showSuccessSnackBar({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
  }) {
    showSnackBar(
      message: message,
      context: context,
      duration: duration,
      textColor: Colors.white,
      backgroundColor: Colors.green,
    );
  }

  static Timer? _snackBarTimer;

  static void showSnackBar({
    required String message,
    required BuildContext context,
    Duration duration = const Duration(seconds: 3),
    Color? textColor,
    Color? backgroundColor,
  }) {
    if (_snackBarTimer != null) {
      return;
    }

    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(
            message,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: textColor,
            ),
          ),
        ),
        duration: duration,
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
      ),
    );

    _snackBarTimer = Timer(duration, () {
      _snackBarTimer?.cancel();
      _snackBarTimer = null;
    });
  }

  static String translateErrorMessage(Object error) {
    if (error is CustomError) {
      switch (error.errorCode) {
        case CustomErrorType.badRequest:
          return Language.current.errorBadRequest;
        case CustomErrorType.parseJsonError:
          return Language.current.errorParseJsonError;
        case CustomErrorType.parameterError:
          return Language.current.errorParameterError;
        case CustomErrorType.serializeJsonError:
          return Language.current.errorSerializeJsonError;
        case CustomErrorType.unKnownError:
          return Language.current.errorUnKnownError;
        case CustomErrorType.lockError:
          return Language.current.errorLockError;
        case CustomErrorType.fileWriteError:
          return Language.current.errorFileWriteError;
        case CustomErrorType.fileReadError:
          return Language.current.errorFileReadError;
      }
    } else {
      return error.toString();
    }
  }
}
