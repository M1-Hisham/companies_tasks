import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companies_tasks/widget/drawer_widget.dart';
import 'package:companies_tasks/widget/tasks_widget.dart';
import 'package:flutter/material.dart';

class TasksHome extends StatefulWidget {
  const TasksHome({super.key});

  @override
  State<TasksHome> createState() => _TasksHomeState();
}

class _TasksHomeState extends State<TasksHome> {
  final List<String> taskCategoryList = [
    'Business',
    'Programming',
    'Design',
    'Marketing',
    'Accounting',
  ];
  static String? taskCategory;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(
        leading: Builder(builder: (context) {
          return IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: const Icon(Icons.menu),
          );
        }),
        title: const Center(
          child: Text(
            'TASKS',
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Task Category'),
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      taskCategory = taskCategoryList[index];
                                    });
                                    Navigator.canPop(context)
                                        ? Navigator.pop(context)
                                        : null;
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
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            taskCategory = null;
                          });
                          Navigator.canPop(context)
                              ? Navigator.pop(context)
                              : null;
                        },
                        child: const Text(
                          'Cancel Filter',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.filter_list_outlined),
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .where('category', isEqualTo: taskCategory)
            // .orderBy('deadline', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasData) {
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text('No Tasks has been uploded'),
              );
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return TasksWidget(
                    uid: snapshot.data!.docs[index],
                  );
                },
              );
            }
          } else {
            return const Center(child: Text('Error'));
          }
        },
      ),
    );
  }
}


// FutureBuilder(
//         future: FireStore().getTasks(category: taskCategory),
//         // initialData: InitialData,
//         builder: (BuildContext context, AsyncSnapshot snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasData) {
//             if (snapshot.data.isEmpty) {
//               return const Scaffold(
//                 body: Center(
//                   child: Text('No Tasks has been uploded'),
//                 ),
//               );
//             } else {
//               return Scaffold(
//                 body: RefreshIndicator(
//                   onRefresh: () async {
//                     setState(() {});
//                   },
//                   child: ListView.builder(
//                     padding: const EdgeInsets.all(8),
//                     itemCount: snapshot.data!.length,
//                     itemBuilder: (context, index) {
//                       return TasksWidget(
//                         uid: snapshot.data![index],
//                       );
//                     },
//                   ),
//                 ),
//               );
//             }
//           }
          
//           else {
//             return const Center(
//               child: Text('ERROR'),
//             );
//           }
//         },
//       ),