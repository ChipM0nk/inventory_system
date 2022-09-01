import 'package:edar_app/presentation/widgets/blocs/bloc_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GenericProvider extends StatelessWidget {
  final Widget child;
  final String route;
  const GenericProvider({required this.child, required this.route, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: BlocProviders.getBlockProvider(route),
      child: child,
    );
  }
}
