import 'package:flutter/material.dart';

import 'modules/splash/presentation/pages/splash_page.dart';
import 'modules/auth/presentation/pages/login_page.dart';
import 'modules/auth/presentation/pages/register_page.dart';

class AppRoutes {
  static const splash = '/splash';
  static const login = '/auth/login';
  static const register = '/auth/register';

  static Map<String, WidgetBuilder> get routes => {
        splash: (_) => const SplashPage(),
        login: (_) => const LoginPage(),
        register: (_) => const RegisterPage(),
      };
}
