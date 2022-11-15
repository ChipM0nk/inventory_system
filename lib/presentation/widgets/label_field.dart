// import 'package:pdf/widgets.dart';

// class LabelField extends StatelessWidget {
//   const LabelField({
//     super.key,
//     required this.label,
//     required this.value,
//     this.labelWidth = 60,
//     this.valueWidth = 230,
//   });

//   final String label;
//   final String value;
//   final double? labelWidth;
//   final double? valueWidth;

//   @override
//   Widget build(BuildContext context) {
//     return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
//       SizedBox(
//           width: 60,
//           child: Text("$label: ",
//               style: const TextStyle(fontWeight: FontWeight.bold))),
//       const SizedBox(width: 10),
//       Container(
//           padding: const EdgeInsets.only(left: 20),
//           decoration: const BoxDecoration(
//               border: Border(bottom: BorderSide(color: Colors.black))),
//           width: 230,
//           child: Text(value))
//     ]);
//   }
// }
