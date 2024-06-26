import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companies_tasks/screens/task_details.dart';
import 'package:flutter/material.dart';
import '../services/auth_services.dart';

class TasksWidget extends StatefulWidget {
  final dynamic uid;
  
  const TasksWidget({super.key, required this.uid});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  void deleteTask() {
    FirebaseFirestore.instance
        .collection('tasks')
        .doc(widget.uid['taskuid'])
        .delete();
    Navigator.pop(context);
  }

  final _authUser = Auth().userUID();
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white70,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: widget.uid['isDone']
            ? const Icon(
                Icons.done_outline_rounded,
                color: Colors.green,
              )
            : const Icon(
                Icons.query_builder_outlined,
                // color: Colors.red,
              ),
        title: Text(
          widget.uid['title'],
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(widget.uid['descripton']),
        trailing: const Icon(Icons.navigate_next_outlined),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TaskDetails(
                
                taskDetaIls: widget.uid,
                uid: widget.uid['uploadedBy'],
              ),
            ),
          );
        },
        onLongPress: () {
          if (_authUser == widget.uid['uploadedBy']) {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    iconColor: Colors.red,
                    icon: IconButton(
                      onPressed: () {
                        deleteTask();
                      },
                      icon: const Icon(
                        Icons.delete,
                        size: 50,
                      ),
                    ),
                  );
                });
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return const AlertDialog(
                    titleTextStyle:
                        TextStyle(fontSize: 20, color: Colors.black),
                    titlePadding: EdgeInsets.all(30),
                    title: Center(
                      child: Text('You dont have access to delete this task'),
                    ),
                  );
                });
          }
        },
      ),
    );
  }
}
