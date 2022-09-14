import 'package:edar_app/presentation/widgets/navbar/header.dart';
import 'package:flutter/material.dart';

class HomePageScroll extends StatefulWidget {
  const HomePageScroll({super.key});

  @override
  State<HomePageScroll> createState() => _HomePageScrollState();
}

class _HomePageScrollState extends State<HomePageScroll> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // title: const Align(
          //   alignment: Alignment.topLeft,
          //   child: Header(),
          // ),
          backgroundColor: Colors.green.shade900,
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: BoxConstraints(minWidth: 500, maxWidth: 700),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  width: 200,
                  height: 500,
                  child: Container(
                    color: Colors.amber,
                  ),
                ),
                SizedBox(
                  width: 500,
                  height: 500,
                  child: Container(
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        )
        // SingleChildScrollView(
        //   child: ListView(
        //     scrollDirection: Axis.horizontal,
        //     children: [
        //       SizedBox(
        //         width: 200,
        //         height: 500,
        //         child: Container(
        //           color: Colors.amberAccent,
        //         ),
        //       ),
        //       SizedBox(
        //         width: 800,
        //         height: 500,
        //         child: Container(
        //           color: Colors.amberAccent,
        //         ),
        //       )
        //     ],
        //   ),
        // ),
        );
  }
}
