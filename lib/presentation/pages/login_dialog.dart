import 'package:edar_app/cubit/auth/auth_cubit.dart';
import 'package:edar_app/presentation/widgets/fields/custom_text_field.dart';
import 'package:edar_app/presentation/widgets/fields/error_message_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginDialog extends StatelessWidget {
  const LoginDialog({super.key});

  @override
  Widget build(BuildContext context) {
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
          ),
        );
      },
    );
    return AlertDialog(
      content: SizedBox(
        height: 150,
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
                stream: BlocProvider.of<AuthCubit>(context).buttonValid,
                builder: (context, snapshot) {
                  return ElevatedButton(
                      onPressed: () => snapshot.hasData
                          ? {BlocProvider.of<AuthCubit>(context).login()}
                          : {},
                      child: const Text("Login"));
                }))
      ],
    );
  }
}
