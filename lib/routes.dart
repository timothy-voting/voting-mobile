import 'package:voting/screens/home.dart';
import 'package:voting/screens/auth/login.dart';
import 'package:voting/screens/rules.dart';
import 'package:voting/screens/splash.dart';

var routes = {
  '/': (context) => const Splash(),
  '/rules': (context) => const Rules(),
  '/home': (context) => const Home(),
  '/login': (context) => const Login(),
};