// import 'package:flutter/material.dart';

// class FilterWidget extends StatefulWidget {
//   FilterWidget({super.key});
//   dynamic taskCategory;
//   @override
//   State<FilterWidget> createState() => _FilterWidgetState();
// }

// class _FilterWidgetState extends State<FilterWidget> {
//   final List<String> taskCategoryList = [
//     'Business',
//     'Programming',
//     'Design',
//     'Marketing',
//     'Accounting',
//   ];

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return AlertDialog(
//       title: const Text('Task Category'),
//       content: SizedBox(
//         width: size.width * 2,
//         child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: taskCategoryList.length,
//           itemBuilder: (context, index) {
//             return Row(
//               children: [
//                 const Icon(Icons.check_circle),
//                 Padding(
//                   padding:
//                       const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
//                   child: TextButton(
//                     onPressed: () {
//                       setState(() {
//                         widget.taskCategory = taskCategoryList[index];
//                       });
//                     },
//                     child: Text(
//                       taskCategoryList[index],
//                       style: const TextStyle(fontSize: 20),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.canPop(context) ? Navigator.pop(context) : null;
//           },
//           child: const Text(
//             'Close',
//             style: TextStyle(fontSize: 18),
//           ),
//         ),
//         TextButton(
//           onPressed: () {},
//           child: const Text(
//             'Cancel Filter',
//             style: TextStyle(fontSize: 18),
//           ),
//         ),
//       ],
//     );
//   }
// }
