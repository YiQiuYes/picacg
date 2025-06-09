import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/pages/login/login_store.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 25, right: 25),
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Text(
                "欢迎使用Picacg",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: _getTabBarWidget(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: _getTextFormFieldWidget(
                labelText: '用户名',
                icon: Icons.email_rounded,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 40),
              child: _getTextFormFieldWidget(
                labelText: '密码',
                icon: Icons.visibility_rounded,
                obscureText: true,
              ),
            ),
            // 忘记密码
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: _getForgotPasswordWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: _getActionButtonWidget(text: "开始", onPressed: () {}),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getTabBarWidget() {
    return TabBar(
      controller: controller,
      splashBorderRadius: BorderRadius.circular(100),
      tabs: [
        Tab(
          child: Text(
            "登录",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Tab(
          child: Text(
            "注册",
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
  }) {
    return TextFormField(
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
          child: IconButton(
            onPressed: getPasswordOnPressed(ref, obscureText),
            icon: Icon(icon),
          ),
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
      onPressed: () {},
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 15),
      ),
      child: Text(
        "忘记密码?",
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
        onPressed: () {},
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Text(
          text,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
