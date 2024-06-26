import 'package:companies_tasks/services/firestore_services.dart';
import 'package:flutter/material.dart';
import '../widget/drawer_widget.dart';
import '../widget/workers_widget.dart';

class AllWorker extends StatefulWidget {
  const AllWorker({super.key});

  @override
  State<AllWorker> createState() => _AllWorkerState();
}

class _AllWorkerState extends State<AllWorker> {
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
    return SafeArea(
      child: Scaffold(
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
          title: const Text(
            'All Worker',
            style: TextStyle(color: Colors.white),
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
        body: FutureBuilder(
            future: FireStore().getWorkerProfile(category: taskCategory),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasData
                  // snapshot.connectionState == ConnectionState.active
                  ) {
                if (snapshot.data.isEmpty) {
                  return const Scaffold(
                    body: Center(
                      child: Text('No Tasks has been uploded'),
                    ),
                  );
                }
                // if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    // final myUser = FirebaseAuth.instance.currentUser;
                    return WorkersWidget(
                      uid: snapshot.data![index],
                      // uid: snapshot.data![index],
                      // name: snapshot.data!.docs[index]['name'],
                      // email: snapshot.data!.docs[index]['email'],
                      // job: snapshot.data!.docs[index]['jobCategory'],
                      // image: snapshot.data!.docs[index]['image'],
                      // phone: snapshot.data!.docs[index]['phone'],
                    );
                  },
                );
                // const Center(child: Text('hasData'));
                // }
                // return const Center(
                //   child: Text('NOHasData'),
                // );
              } else {
                return const Center(
                  child: Text('ERROR'),
                );
              }
            }),
      ),
    );
  }
}
