import 'package:edar_app/cubit/auth/auth_cubit.dart';
import 'package:edar_app/presentation/pages/login_dialog.dart';
import 'package:edar_app/presentation/pages/purchases/purchase_page.dart';
import 'package:edar_app/presentation/widgets/content_card.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:edar_app/presentation/widgets/navbar/header.dart';
import 'package:edar_app/routing/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainContainer extends StatefulWidget {
  const MainContainer({super.key});

  @override
  State<MainContainer> createState() => _MainContainerState();
}

class _MainContainerState extends State<MainContainer> {
  @override
  final List<Widget> _screens = [
    // Content for Home tab
    Container(
        color: Colors.yellow.shade100,
        alignment: Alignment.center,
        child: const ContentCard(
          route: PurchasesRoute,
          child: PurchasePage(),
        )),
    // Content for Feed tab
    Container(
      color: Colors.purple.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Feed',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // Content for Favorites tab
    Container(
      color: Colors.red.shade100,
      alignment: Alignment.center,
      child: const Text(
        'Favorites',
        style: TextStyle(fontSize: 40),
      ),
    ),
    // Content for Settings tab
    Container(
      color: Colors.pink.shade300,
      alignment: Alignment.center,
      child: const Text(
        'Settings',
        style: TextStyle(fontSize: 40),
      ),
    )
  ];

  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).authenticate();
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        var logIn = ElevatedButton(
            onPressed: () => showDialog(
                context: context,
                builder: (_) {
                  BlocProvider.of<AuthCubit>(context).clearError();
                  return BlocProvider(
                    create: (context) => AuthCubit(),
                    child: const LoginDialog(),
                  );
                }),
            child: const Text("Login"));

        return Scaffold(
          // appBar: AppBar(
          //   title: const Header(), // const Text("Responsive site"),
          // ),
          bottomNavigationBar: MediaQuery.of(context).size.width < 640
              ? BottomNavigationBar(
                  currentIndex: _selectedIndex,
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.indigoAccent,
                  // called when one tab is selected
                  onTap: (int index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  // bottom tab items
                  items: const [
                      BottomNavigationBarItem(
                          icon: Icon(Icons.home), label: 'Home'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.feed), label: 'Feed'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.favorite), label: 'Favorites'),
                      BottomNavigationBarItem(
                          icon: Icon(Icons.settings), label: 'Settings')
                    ])
              : null,
          body: BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return Row(
                children: [
                  if (MediaQuery.of(context).size.width >= 640)
                    NavigationRail(
                      extended: true,
                      onDestinationSelected: (int index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      selectedIndex: _selectedIndex,
                      destinations: const [
                        NavigationRailDestination(
                            icon: SizedBox(height: 10, child: Icon(Icons.home)),
                            label: Text('Home')),
                        NavigationRailDestination(
                            icon: Icon(Icons.feed), label: Text('Feed')),
                        NavigationRailDestination(
                            icon: Icon(Icons.favorite),
                            label: Text('Favorites')),
                        NavigationRailDestination(
                            icon: Icon(Icons.settings),
                            label: Text('Settings')),
                      ],

                      // labelType: NavigationRailLabelType.all,
                      selectedLabelTextStyle: const TextStyle(
                        color: Colors.teal,
                      ),

                      unselectedLabelTextStyle: const TextStyle(),
                      // Called when one tab is selected
                      leading: Column(
                        children: [
                          const SizedBox(
                            height: 8,
                          ),
                          const CircleAvatar(
                            radius: 20,
                            child: Icon(Icons.person),
                          ),
                          logIn,
                        ],
                      ),
                    ),
                  Expanded(child: _screens[_selectedIndex])
                ],
              );
            },
          ),
        );
      },
    );
  }
}
