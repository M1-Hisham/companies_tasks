import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:companies_tasks/services/models.dart';

import 'auth_services.dart';

class FireStore {
  var firestoreRef = FirebaseFirestore.instance;
  var userCollRef = FirebaseFirestore.instance.collection('users');
  var userCollRefTask = FirebaseFirestore.instance.collection('tasks');
  createUser({
    required UserData data,
    // required uid,
  }) async {
    // final auth = FirebaseAuth.instance;
    // final User? user = auth.currentUser;
    final uid = Auth().userUID();
    // FireStorage().UploadImage(imagefile: imagefile);
    await userCollRef.doc(uid).set(
          data.toMap(),
        );
  }

  createTask({
    required AddTask data,
    required uuid,
  }) async {
    await userCollRefTask.doc(uuid).set(
          data.toMap(),
        );
  }

  Future<UserData> getUserbydata({required String id}) async {
    // var id = Auth().userUID();
    var ref = userCollRef.doc(id);
    var myData = await ref.get();
    var theTrueData = UserData(uid: id).fromMap(myData.data());
    // theTrueData.uid = ref.id;
    return theTrueData;
  }

  Future<List<UserData>> getWorkerProfile({required category}) async {
    var ref = FirebaseFirestore.instance
        .collection('users')
        .where('jobCategory', isEqualTo: category)
        .orderBy('jobCategory', descending: true);
    var myData = await ref.get();
    var myUserDocs = myData.docs.map((e) => e.data());
    var theTrueData = myUserDocs.map((e) => UserData().fromMap(e));
    var myUserID = myData.docs.map((e) => e.id);
    var theTrueDataList = theTrueData.toList();
    var myUserIDList = myUserID.toList();
    for (int i = 0; i < theTrueDataList.length; i++) {
      theTrueDataList[i].uid = myUserIDList[i];
    }
    return theTrueDataList;
  }

  Future<List<AddTask>> getTasks({required category}) async {
    var ref = FirebaseFirestore.instance
        .collection('tasks')
        .where('category', isEqualTo: category)
        .orderBy('isDone', descending: false);
    var myData = await ref.get();
    var myUserDocs = myData.docs.map((e) => e.data());
    var theTrueData = myUserDocs.map((e) => AddTask().fromMap(e));
    var myUserID = myData.docs.map((e) => e.id);
    var theTrueDataList = theTrueData.toList();
    var myUserIDList = myUserID.toList();
    for (int i = 0; i < theTrueDataList.length; i++) {
      theTrueDataList[i].uid = myUserIDList[i];
    }
    return theTrueDataList;
  }

  // Future<List<Comments>> getComments() async {
  //   var ref = FirebaseFirestore.instance.collection('tasks');
  //   var myData = await ref.get();
  //   var myUserDocs = myData.docs.map((e) => e.data());
  //   var theTrueData = myUserDocs.map((e) => Comments().fromMap(e));
  //   var myUserID = myData.docs.map((e) => e.id);
  //   var theTrueDataList = theTrueData.toList();
  //   var myUserIDList = myUserID.toList();
  //   for (int i = 0; i < theTrueDataList.length; i++) {
  //     theTrueDataList[i].uid = myUserIDList[i];
  //   }
  //   return theTrueDataList;
  // }

  // Read documents
  // Stream<QuerySnapshot> readDocuments() {
  //   return FirebaseFirestore.instance.collection('tasks').snapshots();
  // }

  Future<Comments> getComment({String? id}) async {
    var ref = FirebaseFirestore.instance
        .collection('tasks')
        .doc('30B7DCzA1iMKsAEhO15g');
    var myData = await ref.get();
    var theTrueData = Comments().fromMap(myData.data());
    return theTrueData;
  }

  Future<List<AddTask>> getComm() async {
    var ref = FirebaseFirestore.instance.collection('taska');
    var myData = await ref.get();
    var groupDocs = myData.docs.map((e) => e.data());
    var theTrueData = groupDocs.map((e) => AddTask().fromMap(e));
    var myUserID = myData.docs.map((e) => e.id);
    var theTrueDataList = theTrueData.toList();
    var myUserIDList = myUserID.toList();
    for (int i = 0; i < theTrueDataList.length; i++) {
      theTrueDataList[i].uid = myUserIDList[i];
    }
    return theTrueDataList;
  }
}
