// import 'package:flutter/material.dart';
// import 'package:side_navigation/side_navigation.dart';

// class HomePageScroll extends StatefulWidget {
//   HomePageScroll();

//   @override
//   _HomePageScrollState createState() => _HomePageScrollState();
// }

// class _HomePageScrollState extends State<HomePageScroll> {
//   int selectedIndex = 0;

//   @override
//   Widget build(BuildContext context) {
//     // });

//     List<DataColumn> dataColumns = [
//       DataColumn(label: Text("Col 1")),
//       DataColumn(label: Text("Col 2")),
//     ];
//     // Future.delayed(const Duration(milliseconds: 3000), () {
//     var dataTable = PaginatedDataTable(
//       columns: dataColumns,
//       source: DataSource(),
//       showCheckboxColumn: false,
//       dataRowHeight: 40,
//       columnSpacing: 40,
//       horizontalMargin: 10,
//       rowsPerPage: 10,
//       showFirstLastButtons: true,
//     );

//     List<SideNavigationBarItem> menuList = [
//       SideNavigationBarItem(icon: Icons.home, label: "Home"),
//     ];

//     List content = [
//       SizedBox(
//         height: MediaQuery.of(context).size.height,
//         child: dataTable,
//       )
//     ];
//     return MaterialApp(
//       home: Scaffold(
//         body: Scrollbar(
//           child: ListView(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             children: [
//               ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxWidth: MediaQuery.of(context).size.width,
//                   maxHeight: MediaQuery.of(context).size.height,
//                 ),
//                 child: Row(
//                   children: [
//                     SideNavigationBar(
//                       // header: SideNavigationBarHeader(
//                       //   title: Text(""),
//                       //   subtitle: Text(""),
//                       //   image: Column(
//                       //       mainAxisAlignment: MainAxisAlignment.start,
//                       //       crossAxisAlignment: CrossAxisAlignment.start,
//                       //       children: [
//                       //         Image.asset("/images/edar_logo.jpg"),
//                       //         // Divider(),
//                       //         // Text("login"),
//                       //       ]),
//                       // ),
//                       theme: SideNavigationBarTheme(
//                         backgroundColor: Colors.white,
//                         togglerTheme: SideNavigationBarTogglerTheme.standard(),
//                         itemTheme: SideNavigationBarItemTheme(
//                           unselectedItemColor: Colors.grey[900],
//                         ),
//                         dividerTheme: SideNavigationBarDividerTheme.standard(),
//                       ),
//                       selectedIndex: selectedIndex,
//                       items: menuList,
//                       toggler: SideBarToggler(
//                           expandIcon: Icons.keyboard_arrow_right,
//                           shrinkIcon: Icons.keyboard_arrow_left,
//                           onToggle: () {
//                             print('Toggle');
//                           }),
//                       onTap: (int value) {},
//                     ),
//                     Expanded(
//                       child: content[selectedIndex],
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class DataSource extends DataTableSource {
//   @override
//   DataRow? getRow(int index) {
//     // TODO: implement getRow
//     DataRow.byIndex(cells: [
//       DataCell(Text("text 1")),
//       DataCell(Text("text 2")),
//     ]);
//   }

//   @override
//   // TODO: implement isRowCountApproximate
//   bool get isRowCountApproximate => false;

//   @override
//   // TODO: implement rowCount
//   int get rowCount => 2;

//   @override
//   // TODO: implement selectedRowCount
//   int get selectedRowCount => 0;
// }
