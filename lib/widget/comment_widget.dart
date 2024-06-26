import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companies_tasks/services/firestore_services.dart';
import 'package:flutter/material.dart';

class CommentsWidget extends StatefulWidget {
  const CommentsWidget({
    super.key,
    required this.taskUid,
  });
  final String taskUid;

  @override
  State<CommentsWidget> createState() => _CommentsWidgetState();
}

class _CommentsWidgetState extends State<CommentsWidget> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('tasks')
          .doc(widget.taskUid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return ListView.separated(
            reverse: true,
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            itemCount: snapshot.data!['comments'].length,
            itemBuilder: (context, index) {
              var comment = snapshot.data!['comments'][index]['comment'];
              return FutureBuilder(
                future: FireStore().getUserbydata(
                  id: snapshot.data!['comments'][index]['uid'],
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Flexible(
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.black,
                            backgroundImage: NetworkImage(snapshot.data!.image),
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Flexible(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!.name,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                '$comment',
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(171, 0, 0, 0),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Center(
                      child: Text('else'),
                    );
                  }
                },
              );
            },
            separatorBuilder: (context, index) {
              return const Divider();
            },
          );
        } else {
          return const Text('ERROR');
        }
      },
    );
  }
}
