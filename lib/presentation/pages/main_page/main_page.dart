import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    List<SizedBox> menuList = <SizedBox>[
      SizedBox(
        height: 50,
        child: Row(
          children: [
            Icon(Icons.abc_outlined),
            Text("ABC"),
          ],
        ),
      ),
      SizedBox(
        height: 50,
        child: Row(
          children: [
            Icon(Icons.abc_outlined),
            Text("ABC"),
          ],
        ),
      ),
    ];

    List content = [
      Text("Hello 0"),
      Text("Hello 1"),
    ];
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyMedium!,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          int selectedIdx = 0;
          return Scaffold(
            body: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Container(
                        // A fixed-height child.
                        color: const Color(0xffeeee00), // Yellow
                        width: 120.0,
                        alignment: Alignment.center,
                        child: Column(
                            children: menuList
                                .map((val) => InkWell(
                                      child: val,
                                      onTap: () {
                                        setState(() {
                                          selectedIdx = 1;
                                          print("Selected Index $selectedIdx");
                                        });
                                      },
                                    ))
                                .toList()),
                      ),
                      Expanded(
                        // A flexible child that will grow to fit the viewport but
                        // still be at least as big as necessary to fit its contents.
                        child: Container(
                          color: const Color(0xffee0000), // Red

                          alignment: Alignment.center,
                          child: content[selectedIdx],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
