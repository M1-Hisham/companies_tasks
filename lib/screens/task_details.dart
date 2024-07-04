import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companies_tasks/screens/tasks.dart';
import 'package:companies_tasks/services/auth_services.dart';
import 'package:companies_tasks/services/firestore_services.dart';
import 'package:companies_tasks/services/models.dart';
import 'package:companies_tasks/widget/comment_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskDetails extends StatefulWidget {
  final dynamic taskDetaIls;

  final String uid;
  const TaskDetails({super.key, required this.taskDetaIls, required this.uid});
  @override
  State<TaskDetails> createState() => _TaskDetailsState();
}

class _TaskDetailsState extends State<TaskDetails> {
  static bool _isCommenting = true;
  static bool? _isDone;
  final _authUser = Auth().userUID();
  static TextEditingController commentController = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    _isDone = widget.taskDetaIls['isDone'];
    Size size = MediaQuery.of(context).size;
    var date = widget.taskDetaIls['timeStamp'].toDate();
    List<String> dateParts = widget.taskDetaIls['deadline'].split('-');
    String year = dateParts[0];
    String month = dateParts[1].padLeft(2, '0');
    String day = dateParts[2].padLeft(2, '0');
    String formattedDateString = "$year-$month-$day";
    DateTime dateTime = DateTime.parse(formattedDateString);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white70,
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.03,
              ),
              const Align(
                alignment: Alignment.topCenter,
                child: Text(
                  'Task Details',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.001,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Card(
                  elevation: 15,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Text(
                              'Uploaded by ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blueAccent,
                              ),
                            ),
                            const Spacer(),
                            FutureBuilder(
                              future: FireStore().getUserbydata(id: widget.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasData) {
                                  UserData? data = snapshot.data;
                                  return CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.black,
                                    backgroundImage: NetworkImage(data!.image),
                                  );
                                } else {
                                  return const Text('ERROR');
                                }
                              },
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            FutureBuilder(
                              future: FireStore().getUserbydata(id: widget.uid),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasData) {
                                  UserData? data = snapshot.data;
                                  return Expanded(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '${data!.name}\n${data.jobCategory}',
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return const Text('ERROR');
                                }
                              },
                            ),
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Uploaded on: ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  '${date.year}-${date.month}-${date.day}',
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Row(
                          children: [
                            const Text(
                              'Deadline date: ',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blueAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            Expanded(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  widget.taskDetaIls['deadline'],
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            date.isAfter(dateTime)
                                ? 'No time left'
                                : 'There is more time',
                            style: TextStyle(
                              fontSize: 18,
                              color: date.isAfter(dateTime)
                                  ? Colors.red
                                  : Colors.green,
                            ),
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Done state: ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            _isDone!
                                ? const Text(
                                    'Done ',
                                    style: TextStyle(
                                      // decoration: TextDecoration.underline,
                                      // decorationColor: Colors.blueAccent,
                                      fontSize: 18,
                                      color: Colors.blueAccent,
                                    ),
                                  )
                                : TextButton(
                                    onPressed: () {
                                      if (_authUser ==
                                          widget.taskDetaIls['uploadedBy']) {
                                        FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(widget.taskDetaIls['taskuid'])
                                            .update({'isDone': true});
                                        setState(() {
                                          _isDone = !_isDone!;
                                        });
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const TasksHome();
                                            },
                                          ),
                                        );
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                titleTextStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                                titlePadding:
                                                    EdgeInsets.all(30),
                                                title: Center(
                                                  child: Text(
                                                      'You can\'t perform this action'),
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    child: const Text(
                                      'Done ',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blueAccent,
                                        fontSize: 18,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  ),

                            _isDone!
                                ? const Icon(
                                    Icons.check_box,
                                    color: Colors.green,
                                  )
                                : const SizedBox(),
                            const Spacer(),
                            _isDone!
                                ? TextButton(
                                    onPressed: () {
                                      if (_authUser ==
                                          widget.taskDetaIls['uploadedBy']) {
                                        FirebaseFirestore.instance
                                            .collection('tasks')
                                            .doc(widget.taskDetaIls['taskuid'])
                                            .update({'isDone': false});
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const TasksHome();
                                            },
                                          ),
                                        );
                                        setState(() {
                                          _isDone = !_isDone!;
                                        });
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return const AlertDialog(
                                                titleTextStyle: TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black),
                                                titlePadding:
                                                    EdgeInsets.all(30),
                                                title: Center(
                                                  child: Text(
                                                      'You can\'t perform this action'),
                                                ),
                                              );
                                            });
                                      }
                                    },
                                    child: const Text(
                                      'Not Done yet ',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        decorationColor: Colors.blueAccent,
                                        fontSize: 18,
                                        color: Colors.blueAccent,
                                      ),
                                    ),
                                  )
                                : const Text(
                                    'Not Done yet ',
                                    style: TextStyle(
                                      // decoration:
                                      //     TextDecoration.underline,
                                      // decorationColor: Colors.blueAccent,
                                      fontSize: 18,
                                      color: Colors.blueAccent,
                                    ),
                                  ),
                            _isDone!
                                ? const SizedBox()
                                : const Icon(
                                    Icons.check_box,
                                    color: Colors.red,
                                  ),
                            // const Opacity(
                            //   opacity: 1,
                            //   child: Icon(
                            //     Icons.check_box,
                            //     color: Colors.red,
                            //   ),
                            // )
                          ],
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Task description: ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            " ${widget.taskDetaIls['descripton']}",
                            style: const TextStyle(
                              fontSize: 18,
                              // color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 400),
                          child: _isCommenting
                              ? ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isCommenting = !_isCommenting;
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.black,
                                  ),
                                  child: const Text(
                                    'Add a comment',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Form(
                                      key: formkey,
                                      child: Flexible(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'isEmpty';
                                            }
                                            return null;
                                          },
                                          controller: commentController,
                                          textInputAction: TextInputAction.done,
                                          decoration: const InputDecoration(
                                            filled: true,
                                            fillColor: Color(0xBC9E9E9E),
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          cursorRadius:
                                              const Radius.circular(22),
                                          maxLength: 200,
                                          maxLines: 4,
                                          cursorColor: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            if (formkey.currentState!
                                                .validate()) {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());
                                              setState(() {
                                                _isCommenting = true;
                                              });

                                              FirebaseFirestore.instance
                                                  .collection('tasks')
                                                  .doc(widget
                                                      .taskDetaIls['taskuid'])
                                                  .update({
                                                'comments':
                                                    FieldValue.arrayUnion([
                                                  {
                                                    'comment':
                                                        commentController.text,
                                                    'uid': Auth().userUID()
                                                  }
                                                ]),
                                              });
                                              commentController =
                                                  TextEditingController();
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor: Colors.black,
                                          ),
                                          child: const Text(
                                            'Post',
                                            style: TextStyle(
                                              fontSize: 20,
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _isCommenting = !_isCommenting;
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.black,
                                            backgroundColor: Colors.white,
                                          ),
                                          child: const Text(
                                            'Cancel',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CommentsWidget(
                          taskUid: widget.taskDetaIls['taskuid'],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
