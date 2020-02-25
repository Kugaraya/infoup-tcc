import 'package:flutter/services.dart';
import 'package:infoup/ui/router.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
        break;

      case AppLifecycleState.inactive:
        break;

      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'infoup',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Color(0xff1857a4), accentColor: Color(0xff1f6fd0)),
      initialRoute: '/',
      onGenerateRoute: Router.generateRoute,
    );
  }
}
