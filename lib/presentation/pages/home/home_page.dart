import 'package:edar_app/cubit/auth_cubit.dart';
import 'package:edar_app/presentation/widgets/navbar/custom_menu_list.dart';
import 'package:edar_app/presentation/widgets/navbar/header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_navigation/side_navigation.dart';

import '../../../locator.dart';
import '../../../services/navigation_service.dart';

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
          title: Align(
            child: Header(),
            alignment: Alignment.topLeft,
          ),
          backgroundColor: Colors.green.shade900,
        ),
        body: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            return ListView(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(maxWidth: 1500, maxHeight: 1000),
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
                            print(
                                "Navigating to : ${MenuItemList[index].route}");
                            locator<NavigationService>()
                                .navigateTo(MenuItemList[index].route);
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          toggler: SideBarToggler(
                              expandIcon: Icons.keyboard_arrow_left,
                              shrinkIcon: Icons.keyboard_arrow_right,
                              onToggle: () {
                                print('Toggle');
                              }),
                        ),
                        Expanded(
                          child: BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, state) {
                              print("Auth state is ${state}");
                              if (state is! AuthenticationSuccess) {
                                return Align(
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
