import 'package:edar_app/cubit/auth/auth_cubit.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<AuthCubit>(context).init();

    var username = StreamBuilder(
      stream: BlocProvider.of<AuthCubit>(context).usernameStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: CustomTextField(
              labelText: "Username",
              hintText: "user123",
              snapshot: snapshot,
              autofocus: true,
              onChanged: (text) {
                BlocProvider.of<AuthCubit>(context).udpateUsername(text);
              }),
        );
      },
    );

    var password = StreamBuilder(
      stream: BlocProvider.of<AuthCubit>(context).passwordStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
          child: CustomTextField(
              labelText: "Password",
              hintText: "password",
              obscureText: true,
              snapshot: snapshot,
              autofocus: true,
              onChanged: (text) {
                BlocProvider.of<AuthCubit>(context).udpatePassword(text);
              }),
        );
      },
    );

    var serviceErrorMessage = StreamBuilder(
      stream: BlocProvider.of<AuthCubit>(context).errorStream,
      builder: (context, snapshot) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: ErrorMessage(
            snapshot: snapshot,
            fontSize: 12,
            height: 20,
          ),
        );
      },
    );
    var logIn = ElevatedButton(
        onPressed: () => showDialog(
            context: context,
            builder: (_) {
              BlocProvider.of<AuthCubit>(context).clearError();
              var loginDialog = AlertDialog(
                content: Container(
                  height: 160,
                  child: BlocBuilder<AuthCubit, AuthState>(
                    builder: (context, state) {
                      if (state is AuthenticationSuccess) {
                        Navigator.of(context, rootNavigator: true).pop();
                      }
                      return Column(
                        children: [
                          username,
                          password,
                          serviceErrorMessage,
                        ],
                      );
                    },
                  ),
                ),
                actions: [
                  Center(
                      child: StreamBuilder(
                          stream:
                              BlocProvider.of<AuthCubit>(context).buttonValid,
                          builder: (context, snapshot) {
                            return ElevatedButton(
                                onPressed: () => snapshot.hasData
                                    ? {
                                        BlocProvider.of<AuthCubit>(context)
                                            .login()
                                      }
                                    : {},
                                child: Text("Login"));
                          }))
                ],
              );
              return loginDialog;
            }),
        child: const Text("Login"));

    var logOut = ElevatedButton(
        onPressed: () => {
              BlocProvider.of<AuthCubit>(context).logout(),
            },
        child: const Text("Logout"));

    return Container(
      color: const Color(0xFF08B578),
      child: SizedBox(
        width: 1280,
        height: 60,
        child: Expanded(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(),
            BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is AuthenticationSuccess) {
                  return logOut;
                }
                return logIn;
              },
            ),
          ],
        )),
      ),
    );
  }
}
