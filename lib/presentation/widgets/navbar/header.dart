import 'package:edar_app/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    var logIn = ElevatedButton(
        onPressed: () => {BlocProvider.of<AuthCubit>(context).login()},
        child: const Text("Login"));

    var logOut = ElevatedButton(
        onPressed: () => {BlocProvider.of<AuthCubit>(context).logout()},
        child: const Text("Logout"));

    return Expanded(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("EDAR"),
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if (state is AuthenticationSuccess) {
              return logOut;
            }
            return logIn;
          },
        ),
      ],
    ));
  }
}
