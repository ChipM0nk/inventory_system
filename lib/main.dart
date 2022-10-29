import 'package:edar_app/cubit/auth/auth_cubit.dart';
import 'package:edar_app/locator.dart';
import 'package:edar_app/presentation/pages/main_page/main_page.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:edar_app/routing/router.dart';
import 'package:edar_app/services/navigation_service.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/pages/home/home_page.dart';
import 'presentation/pages/home/main_container.dart';

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
      // home: BlocProvider(
      //   create: (context) => AuthCubit(),
      //   child: MainPage(),
      // ),
      // home: BlocProvider(
      //   create: (context) => AuthCubit(),
      //   child: MainContainer(),
      // ),
      builder: (context, child) => BlocProvider(
        create: (context) => AuthCubit(),
        child: HomePage(child: child!),
      ),
      navigatorKey: locator<NavigationService>().navigatorKey,
      onGenerateRoute: generateRoute,
      initialRoute: InvoiceFormRoute,
    );
  }
}
