import 'package:flutter/material.dart';

import 'blocs/generic_provider.dart';

class ContentCard extends StatelessWidget {
  const ContentCard({Key? key, required this.route, required this.child})
      : super(key: key);

  final Widget child;
  final String route;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // width: 1000,
      // height: 750,
      child: Card(
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GenericProvider(
              route: route,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
