import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:picacg/language/generated/l10n.dart';
import 'package:picacg/provider/config_provider.dart';
import 'package:picacg/router/route_config.dart';
import 'package:picacg/rust/api/error/custom_error.dart';
import 'package:picacg/rust/api/reqs/user.dart';
import 'package:picacg/rust/api/storage/user_data.dart';
import 'package:picacg/utils/toast_util.dart';

mixin LoginStore {
  final tabProvider = StateProvider<int>((ref) => 0);
  final registerTabProvider = StateProvider<int>((ref) => 0);
  final passwordObscureTextProvider = StateProvider<bool>((ref) => true);
  late TabController controller;
  final listviewController = ScrollController();
  final loginUsernameController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final registerNickNameController = TextEditingController();
  final registerUserNameController = TextEditingController();
  final registerPasswordController = TextEditingController();
  final registerSafeQuestion1Controller = TextEditingController();
  final registerSafeAnswer1Controller = TextEditingController();
  final registerSafeQuestion2Controller = TextEditingController();
  final registerSafeAnswer2Controller = TextEditingController();
  final registerSafeQuestion3Controller = TextEditingController();
  final registerSafeAnswer3Controller = TextEditingController();
  final registerPersonalBirthdayController = TextEditingController();
  final registerPersonalGenderController = TextEditingController();
  final loginFormKey = GlobalKey<FormState>();
  final registerBaseInfoFormKey = GlobalKey<FormState>();
  final registerSafeFormKey = GlobalKey<FormState>();
  final registerPersonalFormKey = GlobalKey<FormState>();

  void initTabController(TickerProvider vsync, WidgetRef ref) {
    controller = TabController(
      length: 2,
      vsync: vsync,
      initialIndex: ref.read(tabProvider),
    );
  }

  void onObscureTextChanged(WidgetRef ref) {
    ref.read(passwordObscureTextProvider.notifier).state =
        !ref.read(passwordObscureTextProvider);
  }

  double? getLetterSpacing(WidgetRef ref, bool obscureText) {
    if (obscureText) {
      if (ref.read(passwordObscureTextProvider)) {
        return 10;
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<void> startLogin(WidgetRef ref, BuildContext context) async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    try {
      final username = loginUsernameController.text.trim();
      final password = loginPasswordController.text.trim();
      final result = await picacgUserLogin(
        username: username,
        password: password,
      );

      ToastUtil.showSuccessSnackBar(
        message: Language.of(context).loginSuccessAndJumpToMain,
        context: context,
      );

      ref
          .read(configProvider.notifier)
          .updateUserData(UserData(token: result.token));

      await Future.delayed(const Duration(milliseconds: 1000), () {
        GoRouter.of(context).go(RouteConfig.main);
      });
    } on CustomError catch (e) {
      ToastUtil.showErrorSnackBar(message: e.errorMessage, context: context);
    }
  }

  void registerOnPreviousTab(WidgetRef ref) {
    if (ref.read(registerTabProvider) > 0) {
      listviewController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );

      ref.read(registerTabProvider.notifier).state--;
    }
  }

  void registerOnNextTab(WidgetRef ref) {
    switch (ref.read(registerTabProvider)) {
      case 0:
        if (!registerBaseInfoFormKey.currentState!.validate()) {
          return;
        }
        break;
      case 1:
        if (!registerSafeFormKey.currentState!.validate()) {
          return;
        }
        break;
      default:
        return;
    }

    if (ref.read(registerTabProvider) < 2) {
      listviewController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      ref.read(registerTabProvider.notifier).state++;
    }
  }

  Future<void> startRegister(WidgetRef ref, BuildContext context) async {
    if (!registerPersonalFormKey.currentState!.validate()) {
      return;
    }

    try {
      final nickName = registerNickNameController.text.trim();
      final username = registerUserNameController.text.trim();
      final password = registerPasswordController.text.trim();
      final question1 = registerSafeQuestion1Controller.text.trim();
      final answer1 = registerSafeAnswer1Controller.text.trim();
      final question2 = registerSafeQuestion2Controller.text.trim();
      final answer2 = registerSafeAnswer2Controller.text.trim();
      final question3 = registerSafeQuestion3Controller.text.trim();
      final answer3 = registerSafeAnswer3Controller.text.trim();
      final birthday = registerPersonalBirthdayController.text.trim();
      final sex = registerPersonalGenderController.text.trim();
      String gender;
      switch (sex) {
        case var s when s == Language.of(context).man:
          gender = "m";
          break;
        case var s when s == Language.of(context).lady:
          gender = "f";
          break;
        default:
          gender = "bot";
      }

      await picacgUserRegister(
        email: username,
        password: password,
        name: nickName,
        birthday: birthday,
        gender: gender,
        answer1: answer1,
        answer2: answer2,
        answer3: answer3,
        question1: question1,
        question2: question2,
        question3: question3,
      );

      final result = await picacgUserLogin(
        username: username,
        password: password,
      );

      ToastUtil.showSuccessSnackBar(
        message: Language.of(context).registerSuccessAndJumpToMain,
        context: context,
      );

      ref
          .read(configProvider.notifier)
          .updateUserData(UserData(token: result.token));

      await Future.delayed(const Duration(milliseconds: 1000), () {
        GoRouter.of(context).go(RouteConfig.main);
      });
    } on CustomError catch (e) {
      ToastUtil.showErrorSnackBar(message: e.errorMessage, context: context);
    }
  }

  void selectBirthday(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    ).then((selectedDate) {
      if (selectedDate != null) {
        String formattedDate =
            "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
        registerPersonalBirthdayController.text = formattedDate;
      }
    });
  }

  String? Function(String?)? getLoginUserNameValidator(BuildContext context) {
    return (value) {
      if (value == null || value.isEmpty) {
        return Language.of(context).loginPasswordEmpty;
      }

      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
      if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
        return Language.of(context).loginUserNameValid;
      }

      return null;
    };
  }

  String? Function(String?)? getLoginPasswordValidator(BuildContext context) {
    return (value) {
      if (value == null || value.isEmpty) {
        return Language.of(context).loginPasswordEmpty;
      }

      return null;
    };
  }

  String? Function(String?)? getRegisterNickNameValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
        return Language.of(context).registerNickNameEmpty;
      }

      if (value.length < 2 || value.length > 50) {
        return Language.of(context).registerNickNameLength;
      }

      return null;
    };
  }

  String? Function(String?)? getRegisterUserNameValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
        return Language.of(context).registerUserNameEmpty;
      }

      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
      if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
        return Language.of(context).registerUserNameValid;
      }

      return null;
    };
  }

  String? Function(String?)? getRegisterPasswordValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
        return Language.of(context).registerPasswordEmpty;
      }

      if (value.length < 8) {
        return Language.of(context).registerPasswordLength;
      }

      return null;
    };
  }

  String? Function(String?)? getRegisterSafeQuestionValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
        return Language.of(context).registerSafeQuestionValid;
      }

      return null;
    };
  }

  String? Function(String?)? getRegisterSafeAnswerValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
        return Language.of(context).registerSafeAnswerValid;
      }

      return null;
    };
  }

  String? Function(String?)? getRegisterBirthdayValidator(
    BuildContext context,
  ) {
    return (value) {
      if (value == null || value.isEmpty) {
        return Language.of(context).registerBirthdayEmpty;
      }

      return null;
    };
  }

  String? Function(String?)? getRegisterGenderValidator(BuildContext context) {
    return (value) {
      if (value == null || value.isEmpty) {
        return Language.of(context).registerSexEmpty;
      }

      return null;
    };
  }
}
