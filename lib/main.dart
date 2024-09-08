import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmobril_test/src/Authentication/authentication_service.dart';
import 'package:webmobril_test/src/screen/Register/register_provider.dart';
import 'package:webmobril_test/src/screen/Register/register_view.dart';
import 'package:webmobril_test/src/screen/home/provider/homo_provider.dart';
import 'package:webmobril_test/src/screen/home/view/home_view.dart';
import 'package:webmobril_test/src/screen/login/login_provider.dart';
import 'package:webmobril_test/src/screen/login/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.setLanguageCode('en');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthenticationService()),
        ChangeNotifierProvider(create: (context) => HomeProvider()),
        ChangeNotifierProvider(create: (context) => LoginProvider()),
        ChangeNotifierProvider(create: (context) => RegisterProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter ',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Consumer<AuthenticationService>(
          builder: (context, auth, _) {
            if (auth.user != null) {
              return const HomeScreen();
            } else {
              return LoginScreen();
            }
          },
        ),
        routes: {
          '/register': (context) => RegisterScreen(),
        },
      ),
    );
  }
}
