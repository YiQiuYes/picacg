import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:picacg/language/generated/l10n.dart';
import 'package:picacg/rust/frb_generated.dart';
import 'package:picacg/router/route_config.dart';

Future<void> main() async {
  await RustLib.init();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: const [
        Language.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: Language.delegate.supportedLocales,
      locale: const Locale('zh'),
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale != null && Language.delegate.isSupported(locale)) {
          return locale;
        }
        return const Locale('zh');
      },
      routerConfig: RouteConfig.router,
    );
  }
}
