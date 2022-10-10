import 'package:edar_app/cubit/auth/auth_cubit.dart';
import 'package:edar_app/locator.dart';
import 'package:edar_app/presentation/widgets/navbar/custom_menu_list.dart';
import 'package:edar_app/presentation/widgets/navbar/header.dart';
import 'package:edar_app/services/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_navigation/side_navigation.dart';

class HomePage extends StatefulWidget {
  final Widget child;
  HomePage({required this.child});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).authenticate();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Align(
            alignment: Alignment.topLeft,
            child: Header(),
          ),
          backgroundColor: Colors.green.shade900,
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return ListView(
              children: [
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 1200, maxHeight: 775),
                  child: Row(
                    children: [
                      SideNavigationBar(
                        theme: SideNavigationBarTheme(
                          backgroundColor: Colors.green.shade900,
                          togglerTheme:
                              SideNavigationBarTogglerTheme.standard(),
                          itemTheme: const SideNavigationBarItemTheme(
                            unselectedItemColor: Colors.white,
                          ),
                          dividerTheme:
                              SideNavigationBarDividerTheme.standard(),
                        ),
                        selectedIndex: selectedIndex,
                        items: MenuItemList.map(
                                (menuItem) => menuItem.sideNavigationBarItem)
                            .toList(),
                        onTap: (index) {
                          print("Navigating to : ${MenuItemList[index].route}");
                          locator<NavigationService>()
                              .navigateTo(MenuItemList[index].route);
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        toggler: SideBarToggler(
                            expandIcon: Icons.keyboard_arrow_right,
                            shrinkIcon: Icons.keyboard_arrow_left,
                            onToggle: () {
                              print('Toggle');
                            }),
                      ),
                      Expanded(
                        child: BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            print("Auth state is ${state}");
                            if (state is! AuthenticationSuccess) {
                              return const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                    "Not Allowed"), //TODO Create actual page
                              );
                            }

                            return widget.child;
                          },
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
