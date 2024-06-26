import 'package:companies_tasks/inner_screens/profile.dart';
import 'package:companies_tasks/services/models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkersWidget extends StatelessWidget {
  final UserData uid;
  const WorkersWidget({
    super.key,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.white70,
      margin: const EdgeInsets.all(8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 40,
          backgroundColor: Colors.black,
          backgroundImage: NetworkImage(uid.image),
        ),
        title: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                uid.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const Divider(
              thickness: 2,
              endIndent: 120,
            )
          ],
        ),
        subtitle: Text('${uid.jobCategory} / ${uid.phone}'),
        trailing: IconButton(
          onPressed: () async {
            await launchUrl(Uri.parse('mailto:${uid.email}'),
                mode: LaunchMode.externalApplication);
          },
          icon: const Icon(Icons.mail_outline_rounded),
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) {
              return ProfileScreen(
                uid: uid.uid,
              );
            },
          ));
        },
      ),
    );
  }
}
