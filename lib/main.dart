import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:timetable_2_demo/stores/check_connectivity.dart';

import './pages/home_page.dart';
import './pages/splash_page.dart';
import './stores/login_store.dart';
import './stores/database.dart';
import './pages/login-page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('Something has gone wrong!');
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              Provider<LoginStore>(
                create: (_) => LoginStore(),
              ),
              ChangeNotifierProvider.value(
                value: Database(),
              ),
              ChangeNotifierProvider.value(
                value: ConnectivityChangeNotifier(),
              ),
            ],
            child: MaterialApp(
              title: 'Timetable',
              debugShowCheckedModeBanner: false,
              home: SplashPage(),
              routes: {
                HomePage.routeName: (ctx) => HomePage(),
                LoginPage.routeName: (ctx) => LoginPage(),
              },
            ),
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
