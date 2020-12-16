import 'constants.dart';
import 'routes.dart';
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppTitle,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Lato',
        textTheme: TextTheme(
          headline3: Theme.of(context).textTheme.headline3.copyWith(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
              ),
        ),
      ),
      routes: routes,
      initialRoute: HomeScreen.routeName,
    );
  }
}
