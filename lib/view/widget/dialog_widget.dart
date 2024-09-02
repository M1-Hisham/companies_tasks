import 'package:flutter/material.dart';

class DialogWidget extends StatefulWidget {
  const DialogWidget({super.key, required this.categorycontroller});
  final TextEditingController categorycontroller;

  @override
  State<DialogWidget> createState() => _DialogWidgetState();
}

class _DialogWidgetState extends State<DialogWidget> {
  final List<String> taskCategoryList = [
    'Business',
    'Programming',
    'Design',
    'Marketing',
    'Accounting',
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AlertDialog(
      title: const Text('Category..'),
      content: SizedBox(
        width: size.width * 2,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: taskCategoryList.length,
          itemBuilder: (context, index) {
            return Row(
              children: [
                const Icon(Icons.check_circle),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        widget.categorycontroller.text =
                            taskCategoryList[index];
                      });
                      Navigator.pop(context);
                    },
                    child: Text(
                      taskCategoryList[index],
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.canPop(context) ? Navigator.pop(context) : null;
          },
          child: const Text(
            'Close',
            style: TextStyle(fontSize: 18),
          ),
        ),
      ],
    );
  }
}
