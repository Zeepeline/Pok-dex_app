import 'package:flutter/material.dart';
import 'package:pokedex_app/core/constants/app_route.dart';
import 'package:pokedex_app/core/constants/app_state.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context, listen: false);
    return MaterialApp.router(
      title: 'Flutter Demo',
      routerDelegate: MyRouterDelegate(appState),
      // home: MainNavigation(),
    );
  }
}
