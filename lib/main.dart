import 'package:edar_app/cubit/auth_cubit.dart';
import 'package:edar_app/locator.dart';
import 'package:edar_app/presentation/pages/home/home_page.dart';

import 'package:edar_app/routing/router.dart';
import 'package:edar_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routing/route_names.dart';

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      builder: (context, child) => BlocProvider(
        create: (context) => AuthCubit(),
        child: HomePage(child: child!),
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: SalesRoute,
    );
  }
}
