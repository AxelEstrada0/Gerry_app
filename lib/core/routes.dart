import 'package:flutter/material.dart';
import '../pages/login_page.dart';
import '../pages/register_page.dart';
import '../pages/dashboard_page.dart';
import '../pages/profile_page.dart';
import '../pages/settings_page.dart';
import '../pages/training_page.dart';
import '../pages/history_page.dart';
import '../pages/store_page.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const dashboard = '/dashboard';
  static const profile = '/profile';
  static const settings = '/settings';
  static const training = '/training';
  static const history = '/history';
  static const store = '/store';

  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginPage(),
    register: (context) => const RegisterPage(),
    dashboard: (context) => const DashboardPage(),
    profile: (context) => const ProfilePage(),
    settings: (context) => const SettingsPage(),
    training: (context) => const TrainingPage(),
    history: (context) => const HistoryPage(),
    store: (context) => const StorePage(),
  };
}
