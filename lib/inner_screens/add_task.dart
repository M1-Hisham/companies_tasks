import 'package:companies_tasks/screens/tasks.dart';
import 'package:companies_tasks/services/auth_services.dart';
import 'package:companies_tasks/services/firestore_services.dart';
import 'package:companies_tasks/services/models.dart';
import 'package:companies_tasks/widget/dialog_widget.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../widget/drawer_widget.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});
  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController _categorycontroller = TextEditingController();
  // TextEditingController(text: 'Task category');
  final TextEditingController _descriptoncontroller = TextEditingController();
  // TextEditingController(text: 'descripton');
  final TextEditingController _titlecontroller = TextEditingController();
  // =TextEditingController(text: 'Task title');
  final TextEditingController _datecontroller = TextEditingController();
  // TextEditingController(text: 'Pick up a date');
  DateTime? _dateTime;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        drawer: const DrawerWidget(),
        appBar: AppBar(),
        backgroundColor: Colors.white70,
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: SingleChildScrollView(
            child: Card(
              elevation: 15,
              color: Colors.white,
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'All field are required',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(
                    thickness: 2,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Form(
                    key: formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          const Titel(
                            titel: 'Task category*',
                          ),
                          _textFormField(
                            enabled: false,
                            maxLength: 100,
                            controller: _categorycontroller,
                            fct: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return DialogWidget(
                                    categorycontroller: _categorycontroller,
                                  );
                                },
                              );
                            },
                            valueKey: 'Task category',
                          ),
                          const Titel(
                            titel: 'Task title*',
                          ),
                          _textFormField(
                            enabled: true,
                            maxLength: 100,
                            controller: _titlecontroller,
                            fct: () {},
                            valueKey: 'Task title',
                          ),
                          const Titel(
                            titel: 'Task description*',
                          ),
                          _textFormField(
                            enabled: true,
                            maxLength: 1000,
                            controller: _descriptoncontroller,
                            fct: () {},
                            valueKey: 'TaskDescription',
                          ),
                          const Titel(
                            titel: 'Deadline date*',
                          ),
                          _textFormField(
                            enabled: false,
                            maxLength: 100,
                            valueKey: 'Deadline date',
                            controller: _datecontroller,
                            fct: () async {
                              _dateTime = await showDatePicker(
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Colors
                                            .black, // header background color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                            // foregroundColor:
                                            //     Colors.red, // button text color
                                            ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now()
                                    .subtract(const Duration(days: 2)),
                                lastDate: DateTime(2100),
                              );

                              _datecontroller.text =
                                  '${_dateTime?.year}-${_dateTime?.month}-${_dateTime?.day}';
                              _datecontroller.text == 'null-null-null'
                                  ? _datecontroller.text = ''
                                  : _datecontroller.text =
                                      '${_dateTime?.year}-${_dateTime?.month}-${_dateTime?.day}';

                              // setState(() {
                              //   _datecontroller.text =
                              //       '${_dateTime!.year}-${_dateTime!.month}-${_dateTime!.day}';
                              // });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            onTap: () {
                              if (formkey.currentState!.validate()) {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (context) => const TasksHome(),
                                ));
                                final uuid = const Uuid().v4();
                                FireStore().createTask(
                                    uuid: uuid,
                                    data: AddTask(
                                      category: _categorycontroller.text,
                                      deadline: _datecontroller.text,
                                      descripton: _descriptoncontroller.text,
                                      title: _titlecontroller.text,
                                      uploadedBy: Auth().userUID(),
                                      taskuid: uuid,
                                    ));
                              }
                            },
                            child: Container(
                              height: 50,
                              width: 200,
                              color: Colors.black,
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Upload',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 25),
                                    ),
                                    SizedBox(
                                      width: 16,
                                    ),
                                    Icon(
                                      Icons.upload_file_outlined,
                                      color: Colors.white,
                                      size: 25,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Titel extends StatelessWidget {
  const Titel({super.key, required this.titel});
  final String titel;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Align(
        alignment: Alignment.topLeft,
        child: Text(
          titel,
          style: const TextStyle(fontSize: 23),
        ),
      ),
    );
  }
}

_textFormField({
  required String valueKey,
  required int maxLength,
  required bool enabled,
  required TextEditingController controller,
  required Function fct,
}) {
  return InkWell(
    onTap: () {
      fct();
    },
    child: TextFormField(
      controller: controller,
      validator: (value) {
        if (value!.isEmpty) {
          return 'field is missing';
        }
        return null;
      },
      enabled: enabled,
      // key: ValueKey(valueKey),
      style: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      maxLines: valueKey == 'TaskDescription' ? 3 : 1,
      maxLength: maxLength,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: valueKey,
        filled: true,
        fillColor: const Color.fromARGB(189, 158, 158, 158),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
          ),
        ),
      ),
    ),
  );
}
