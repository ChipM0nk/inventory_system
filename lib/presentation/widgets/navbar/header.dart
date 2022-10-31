import 'package:edar_app/cubit/auth/auth_cubit.dart';
import 'package:edar_app/presentation/pages/login_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).init();

    var logIn = TextButton(
        onPressed: () => showDialog(
            context: context,
            builder: (_) {
              BlocProvider.of<AuthCubit>(context).clearError();

              return const LoginDialog();
            }),
        child: Text(
          "LOGIN",
          style:
              TextStyle(color: Colors.green[50], fontWeight: FontWeight.bold),
        ));

    var logOut = TextButton(
        onPressed: () => {
              BlocProvider.of<AuthCubit>(context).logout(),
            },
        child: Text(
          "LOGOUT",
          style:
              TextStyle(color: Colors.green[50], fontWeight: FontWeight.bold),
        ));

    return Container(
      color: Colors.green.shade900,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthenticationSuccess) {
                  return logOut;
                }
                return logIn;
              },
            ),
          ],
        ),
      ),
    );
  }
}
