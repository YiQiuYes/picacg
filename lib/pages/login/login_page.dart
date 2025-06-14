import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';
import 'package:picacg/language/generated/l10n.dart';
import 'package:picacg/pages/login/login_store.dart';
import 'package:picacg/utils/toast_util.dart';
import 'package:picacg/widgets/indicator_widget.dart';
import 'package:picacg/widgets/responsive_widget.dart';
import 'package:picacg/widgets/tab_switch_widget.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage>
    with SingleTickerProviderStateMixin, LoginStore {
  @override
  void initState() {
    super.initState();
    initTabController(this, ref);
  }

  @override
  void dispose() {
    controller.dispose();
    loginUsernameController.dispose();
    loginPasswordController.dispose();
    registerNickNameController.dispose();
    registerUserNameController.dispose();
    registerPasswordController.dispose();
    registerSafeQuestion1Controller.dispose();
    registerSafeAnswer1Controller.dispose();
    registerSafeQuestion2Controller.dispose();
    registerSafeAnswer2Controller.dispose();
    registerSafeQuestion3Controller.dispose();
    registerSafeAnswer3Controller.dispose();
    registerPersonalBirthdayController.dispose();
    registerPersonalGenderController.dispose();
    listviewController.dispose();
    loginFormKey.currentState?.dispose();
    registerBaseInfoFormKey.currentState?.dispose();
    registerSafeFormKey.currentState?.dispose();
    registerPersonalFormKey.currentState?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        controller: listviewController,
        children: [
          ResponsiveWidget(
            mobile: _getMainBodyWidget(),
            folded: Center(
              child: SizedBox(width: 340, child: _getMainBodyWidget()),
            ),
            tablet: Center(
              child: SizedBox(
                width: 680,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: _getDeputyBodyWidget()),
                    Expanded(flex: 1, child: _getMainBodyWidget()),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getDeputyBodyWidget() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              "欢迎使用Picacg",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, right: 10),
          child: SizedBox(
            height: 250,
            child: Lottie.asset(
              "lib/assets/lotties/login.json",
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
      ],
    );
  }

  Widget _getMainBodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ResponsiveWidget(
          mobile: Padding(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
            child: Text(
              Language.of(context).greeting,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          folded: Padding(
            padding: const EdgeInsets.only(top: 60, left: 25, right: 25),
            child: Text(
              Language.of(context).greeting,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 70, left: 25, right: 25),
          child: _getTabBarWidget(),
        ),
        TabSwitchWidget(
          currentIndex: ref.watch(tabProvider),
          children: [_getLoginWidget(), _getRegisterWidget()],
        ),
        SizedBox(height: 50),
      ],
    );
  }

  Widget _getLoginWidget() {
    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).userName,
              icon: Icons.email_rounded,
              controller: loginUsernameController,
              validator: getLoginUserNameValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).password,
              icon: Icons.visibility_rounded,
              obscureText: true,
              onSuffixIconPressed: () {
                onObscureTextChanged(ref);
              },
              controller: loginPasswordController,
              validator: getLoginPasswordValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 25, right: 25),
            child: Align(
              alignment: Alignment.centerRight,
              child: _getForgotPasswordWidget(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 25, right: 25),
            child: _getActionButtonWidget(
              text: Language.of(context).start,
              onPressed: () {
                startLogin(ref, context);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRegisterBaseInfoWidget() {
    return Form(
      key: registerBaseInfoFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
            child: Text(
              Language.of(context).baseInfo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).nickName,
              icon: Icons.person_rounded,
              controller: registerNickNameController,
              validator: getRegisterNickNameValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).userName,
              icon: Icons.email_rounded,
              controller: registerUserNameController,
              validator: getRegisterUserNameValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).password,
              icon: Icons.visibility_rounded,
              controller: registerPasswordController,
              obscureText: true,
              onSuffixIconPressed: () {
                onObscureTextChanged(ref);
              },
              validator: getRegisterPasswordValidator(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRegisterSafeQuestionWidget() {
    return Form(
      key: registerSafeFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
            child: Text(
              Language.of(context).safeInfo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).safeQuestionIndex(1),
              icon: Icons.help_rounded,
              controller: registerSafeQuestion1Controller,
              validator: getRegisterSafeQuestionValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).safeAnswerIndex(1),
              icon: Icons.question_answer_rounded,
              controller: registerSafeAnswer1Controller,
              validator: getRegisterSafeAnswerValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).safeQuestionIndex(2),
              icon: Icons.help_rounded,
              controller: registerSafeQuestion2Controller,
              validator: getRegisterSafeQuestionValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).safeAnswerIndex(2),
              icon: Icons.question_answer_rounded,
              controller: registerSafeAnswer2Controller,
              validator: getRegisterSafeAnswerValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).safeQuestionIndex(3),
              icon: Icons.help_rounded,
              controller: registerSafeQuestion3Controller,
              validator: getRegisterSafeQuestionValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).safeAnswerIndex(3),
              icon: Icons.question_answer_rounded,
              controller: registerSafeAnswer3Controller,
              validator: getRegisterSafeAnswerValidator(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getPersonalSexItemWidget({
    required String svgPath,
    required String labelText,
  }) {
    return InkWell(
      onTap: () {
        registerPersonalGenderController.text = labelText;
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          children: [
            SvgPicture.asset(
              svgPath,
              colorFilter: ColorFilter.mode(
                Theme.of(context).colorScheme.primary,
                BlendMode.srcIn,
              ),
              width: 50,
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                labelText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getRegisterPersonInfo() {
    return Form(
      key: registerPersonalFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
            child: Text(
              Language.of(context).personalInfo,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).birthday,
              icon: Icons.date_range_rounded,
              controller: registerPersonalBirthdayController,
              onTap: () {
                selectBirthday(context);
              },
              canRequestFocus: false,
              validator: getRegisterBirthdayValidator(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 25, right: 25),
            child: _getTextFormFieldWidget(
              labelText: Language.of(context).sex,
              icon: Icons.email_rounded,
              controller: registerPersonalGenderController,
              validator: getRegisterGenderValidator(context),
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return SizedBox(
                      height: 320,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                bottom: 30,
                              ),
                              child: Container(
                                width: 50,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _getPersonalSexItemWidget(
                                svgPath: "lib/assets/svg/man.svg",
                                labelText: Language.of(context).man,
                              ),
                              _getPersonalSexItemWidget(
                                svgPath: "lib/assets/svg/lady.svg",
                                labelText: Language.of(context).lady,
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: _getPersonalSexItemWidget(
                              svgPath: "lib/assets/svg/bot.svg",
                              labelText: Language.of(context).bot,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              canRequestFocus: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getRegisterWidget() {
    return Column(
      key: const ValueKey('register'),
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
          child: IndicatorWidget(
            prossess: ref.watch(registerTabProvider),
            count: 3,
          ),
        ),
        TabSwitchWidget(
          currentIndex: ref.watch(registerTabProvider),
          children: [
            _getRegisterBaseInfoWidget(),
            _getRegisterSafeQuestionWidget(),
            _getRegisterPersonInfo(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: ref.watch(registerTabProvider) > 0,
                child: _getOutlinedButtonWidget(
                  icon: Icons.arrow_back_ios_rounded,
                  text: Language.of(context).back,
                  iconAlignment: IconAlignment.start,
                  onPressed: () {
                    registerOnPreviousTab(ref);
                  },
                ),
              ),
              if (ref.watch(registerTabProvider) < 2)
                _getOutlinedButtonWidget(
                  icon: Icons.arrow_forward_ios_rounded,
                  text: Language.of(context).next,
                  iconAlignment: IconAlignment.end,
                  onPressed: () {
                    registerOnNextTab(ref);
                  },
                ),
              if (ref.watch(registerTabProvider) == 2)
                _getOutlinedButtonWidget(
                  icon: Icons.check_rounded,
                  text: Language.of(context).register,
                  iconAlignment: IconAlignment.start,
                  onPressed: () {
                    startRegister(ref, context);
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _getOutlinedButtonWidget({
    required String text,
    required IconData icon,
    required VoidCallback onPressed,
    IconAlignment? iconAlignment,
  }) {
    EdgeInsets padding;
    if (iconAlignment == IconAlignment.start) {
      padding = const EdgeInsets.only(left: 15, right: 20, top: 10, bottom: 10);
    } else {
      padding = const EdgeInsets.only(left: 20, right: 15, top: 10, bottom: 10);
    }

    return OutlinedButton.icon(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: WidgetStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        padding: WidgetStateProperty.all<EdgeInsets>(padding),
      ),
      icon: Icon(icon),
      label: Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
      iconAlignment: iconAlignment,
    );
  }

  Widget _getTabBarWidget() {
    return TabBar(
      controller: controller,
      splashBorderRadius: BorderRadius.circular(100),
      onTap: (index) {
        listviewController.animateTo(
          0,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastEaseInToSlowEaseOut,
        );
        ref.read(tabProvider.notifier).state = index;
      },
      tabs: [
        Tab(
          child: Text(
            Language.of(context).login,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Tab(
          child: Text(
            Language.of(context).register,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
      ],
    );
  }

  Widget _getTextFormFieldWidget({
    String? labelText,
    required IconData icon,
    bool obscureText = false,
    Function()? onSuffixIconPressed,
    Function()? onTap,
    canRequestFocus = true,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      onTap: onTap,
      controller: controller,
      validator: validator,
      canRequestFocus: canRequestFocus,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        letterSpacing: getLetterSpacing(ref, obscureText),
      ),
      obscureText: obscureText && ref.watch(passwordObscureTextProvider),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: IconButton(onPressed: onSuffixIconPressed, icon: Icon(icon)),
        ),
        suffixIconConstraints: const BoxConstraints(
          minHeight: 25,
          minWidth: 25,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
    );
  }

  Widget _getForgotPasswordWidget() {
    return TextButton(
      onPressed: () {
        ToastUtil.showInfoSnackBar(message: '此功能暂未实现', context: context);
      },
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 15),
      ),
      child: Text(
        Language.of(context).forgotPassword,
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _getActionButtonWidget({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: FloatingActionButton(
        onPressed: onPressed,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
