import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TasksViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _taskCategory;
  final List<String> _taskCategoryList = [
    'Business',
    'Programming',
    'Design',
    'Marketing',
    'Accounting',
  ];

  String? get taskCategory => _taskCategory;
  List<String> get taskCategoryList => _taskCategoryList;

  void setTaskCategory(String category) {
    _taskCategory = category;
    notifyListeners();
  }

  void clearTaskCategory() {
    _taskCategory = null;
    notifyListeners();
  }

  Stream<QuerySnapshot> getTasks() {
    return _firestore
        .collection('tasks')
        .where('category', isEqualTo: _taskCategory)
        .snapshots();
  }
}
