import 'package:edar_app/cubit/auth/auth_cubit.dart';
import 'package:edar_app/locator.dart';
import 'package:edar_app/presentation/widgets/navbar/custom_menu_Item.dart';
import 'package:edar_app/presentation/widgets/navbar/custom_menu_list.dart';
import 'package:edar_app/presentation/widgets/navbar/header.dart';
import 'package:edar_app/routing/route_names.dart';
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
    // });
    BlocProvider.of<AuthCubit>(context).authenticate();
    final initialInvoiceMenuList = CustomMenuItem(
        sideNavigationBarItem: const SideNavigationBarItem(
          icon: Icons.point_of_sale,
          label: 'Invoice Form',
        ),
        // page: const SalesForm(),
        route: InvoiceFormRoute);

    List<CustomMenuItem> userMenuList = [initialInvoiceMenuList];
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthenticationSuccess) {
          List<String> menuList =
              BlocProvider.of<AuthCubit>(context).getUserInfo().menuList!;
          userMenuList = MenuItemList.where((el1) => menuList.any(
                  (el2) => el1.route.toLowerCase().contains(el2.toLowerCase())))
              .toList();
        } else {
          locator<NavigationService>().navigateTo(InvoiceFormRoute);
          userMenuList = [initialInvoiceMenuList];
        }
      },

      // Future.delayed(const Duration(milliseconds: 3000), () {

      child: MaterialApp(
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
                        const BoxConstraints(maxWidth: 1200, maxHeight: 750),
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
                          items: userMenuList
                              .map((menuItem) => menuItem.sideNavigationBarItem)
                              .toList(),
                          onTap: (index) {
                            print(
                                "Navigating to : ${userMenuList[index].route}");
                            locator<NavigationService>()
                                .navigateTo(userMenuList[index].route);
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
      ),
    );
  }
}
