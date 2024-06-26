import 'package:companies_tasks/screens/edit_screen.dart';
import 'package:companies_tasks/services/auth_services.dart';
import 'package:companies_tasks/services/firestore_services.dart';
import 'package:companies_tasks/services/models.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../widget/drawer_widget.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({super.key, required this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authUser = Auth().userUID();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: FireStore().getUserbydata(id: widget.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.white70,
            drawer: const DrawerWidget(),
            appBar: AppBar(),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Stack(alignment: Alignment.topCenter, children: [
                  Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 35, horizontal: 30),
                    color: const Color.fromARGB(150, 255, 255, 255),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        const Text(
                          '~~~~~',
                          style: TextStyle(
                              fontSize: 25,
                              color: Color.fromARGB(150, 0, 0, 0),
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Text(
                          '~~~~~~~~~',
                          style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(150, 68, 137, 255)),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Divider(
                          color: Color.fromARGB(41, 255, 255, 255),
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              '~~~~~~~~~~~~~~',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(150, 0, 0, 0),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                '~~~~~~',
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Color.fromARGB(150, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Text(
                                '~~~~~~~~~~~~',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color.fromARGB(150, 68, 137, 255),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                '~~~~~~~~~',
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Color.fromARGB(150, 0, 0, 0),
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  '~~~~~~~~~~~~~',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(150, 68, 137, 255),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                        ),
                        const Divider(
                          color: Color.fromARGB(41, 255, 255, 255),
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: size.height * 0.05,
                          width: size.height * 0.2,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(150, 0, 0, 0),
                              borderRadius: BorderRadius.circular(24)),
                          child: const Center(
                            child: Text(
                              '~~~~~',
                              style: TextStyle(
                                  color: Color.fromARGB(150, 255, 255, 255),
                                  fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Ink(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Color.fromARGB(150, 255, 255, 255),
                          borderRadius: BorderRadius.all(Radius.circular(120))),
                      child: const CircleAvatar(
                        radius: 55,
                        backgroundColor: Color.fromARGB(150, 0, 0, 0),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          );
          // const Scaffold(
          //   body: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [Center(child: CircularProgressIndicator())],
          //   ),
          // );
        } else if (snapshot.hasData) {
          UserData? data = snapshot.data;
          return Scaffold(
            backgroundColor: Colors.white70,
            drawer: const DrawerWidget(),
            appBar: AppBar(
              actions: [
                PopupMenuButton<String>(
                  onSelected: (String result) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditScreen(
                        name: data!.name,
                        email: data.email,
                        phone: data.phone,
                        image: data.image,
                      ),
                    ));
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'Edit',
                      child: Text('Edit'),
                    ),
                  ],
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Stack(alignment: Alignment.topCenter, children: [
                  Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 35, horizontal: 30),
                    color: Colors.white,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 80,
                        ),
                        Text(
                          data!.name,
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          data.jobCategory,
                          style: const TextStyle(
                              fontSize: 20, color: Colors.blueAccent),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Contact info👇',
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Email',
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  data.email,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Text(
                                'Phone number',
                                style: TextStyle(
                                    fontSize: 23,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  data.phone,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: () => _whatsApp(data.phone),
                                child: Image.asset(
                                  'assets/whatsapp.png',
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              InkWell(
                                onTap: () => _mailTo(data.email),
                                child: Image.asset(
                                  'assets/gmail.png',
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              InkWell(
                                onTap: () => _call(data.phone),
                                child: Image.asset(
                                  'assets/call.png',
                                  height: 60,
                                  width: 60,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        _authUser == widget.uid
                            ? InkWell(
                                onTap: () {
                                  // print('${widget.uid}');
                                  Auth().userLogout(context: context);
                                },
                                child: Container(
                                  height: size.height * 0.05,
                                  width: size.height * 0.2,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(24)),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'LOGOUT',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 25),
                                        ),
                                        SizedBox(
                                          width: size.width * 0.02,
                                        ),
                                        const Icon(
                                          Icons.logout,
                                          color: Colors.white,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                        const SizedBox(
                          height: 12,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    child: Ink(
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(120))),
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(data.image),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'hasError',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        } else {
          return const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'else',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
          );
        }
      },
    );
  }

  void _whatsApp(number) async {
    await launchUrlString('https://wa.me/$number?text=Hello,\ni am APP',
        mode: LaunchMode.externalApplication);
  }

  void _mailTo(email) async {
    await launchUrl(Uri.parse('mailto:$email'),
        mode: LaunchMode.externalApplication);
  }

  void _call(number) async {
    var url = 'tel:$number';
    await launchUrl(Uri.parse(url));
    // if (await canLaunchUrl(Uri.parse(url))) {
    //    launchUrl(Uri.parse(url));
    // } else {
    //   throw 'Error occured coulnd\'t open link';
    // }
  }
}
