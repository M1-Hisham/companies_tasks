import 'package:companies_tasks/inner_screens/add_task.dart';
import 'package:companies_tasks/inner_screens/all_workers.dart';
import 'package:companies_tasks/inner_screens/profile.dart';
import 'package:companies_tasks/screens/tasks.dart';
import 'package:companies_tasks/services/auth_services.dart';
import 'package:companies_tasks/services/firestore_services.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});
  // final  data = FireStore().getUserbydata(id: Auth().userUID());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Drawer(
        child: ListView(
          children: [
            SizedBox(
              height: size.height * 0.3,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    FutureBuilder(
                      future: FireStore().getUserbydata(id: Auth().userUID()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Flexible(
                            child: CircleAvatar(
                              radius: 50,
                              // backgroundColor: Colors.white,
                              backgroundImage:
                                  NetworkImage(snapshot.data!.image),
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Flexible(
                            child: CircleAvatar(
                              radius: 110,
                              backgroundColor: Colors.transparent,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else {
                          return const Flexible(
                            child: CircleAvatar(
                              radius: 110,
                              backgroundColor: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(
                      height: size.height * 0.03,
                    ),
                    FutureBuilder(
                      future: FireStore().getUserbydata(id: Auth().userUID()),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Flexible(
                            child: Text(
                              snapshot.data!.name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white),
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return const Flexible(
                            child: Text(
                              'ERROR',
                              // 'name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                  color: Colors.white),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.task_outlined,
                size: 30,
              ),
              title: const Text(
                'All Tasks',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const TasksHome();
                  },
                ));
              },
            ),
            ListTile(
                leading: const Icon(
                  Icons.settings,
                  size: 30,
                ),
                title: const Text(
                  'My account',
                  style: TextStyle(fontSize: 20),
                ),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) {
                        return ProfileScreen(
                          uid: Auth().userUID(),
                        );
                      },
                    ),
                  );
                }),
            ListTile(
              leading: const Icon(
                Icons.app_registration,
                size: 30,
              ),
              title: const Text(
                'Registered Workers',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return  AllWorker();
                  },
                ));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.add_task,
                size: 30,
              ),
              title: const Text(
                'Add task',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) {
                    return const AddTaskScreen();
                  },
                ));
              },
            ),
            SizedBox(
              height: size.height * 0.04,
              width: double.infinity,
              child: const Divider(
                endIndent: 20,
                indent: 20,
                thickness: 2,
                color: Colors.black,
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.logout,
                size: 30,
              ),
              title: const Text(
                'Logout',
                style: TextStyle(fontSize: 20),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Row(
                        children: [
                          Icon(Icons.logout_outlined),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Sign out',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                            ),
                          )
                        ],
                      ),
                      content: const Text(
                        'Do you wanna Sign out?',
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.black,
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
                            'Cancel',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Auth().userLogout(context: context);
                          },
                          child: const Text(
                            'Ok',
                            style: TextStyle(fontSize: 18, color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
