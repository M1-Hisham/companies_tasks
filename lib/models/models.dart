class UserData {
  String name;
  String phone;
  String email;
  String jobCategory;
  String image;
  String uid;
  UserData({
    this.name = '',
    this.phone = '',
    this.email = '',
    this.jobCategory = '',
    this.image = '',
    this.uid = '',
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'phone': phone,
      'email': email,
      'jobCategory': jobCategory,
      'image': image,
    };
  }

  UserData fromMap(Map<String, dynamic>? map) {
    return UserData(
      name: map!['name'],
      phone: map['phone'],
      email: map['email'],
      jobCategory: map['jobCategory'],
      image: map['image'],
    );
  }

  // String toJson() => json.encode(toMap());

  // factory UserData.fromJson(String source) =>
  //     UserData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AddTask {
  String title;
  String descripton;
  String category;
  String deadline;
  List comments;
  String taskuid;
  String uid;
  String uploadedBy;
  bool isDone;
  dynamic timeStamp;

  AddTask({
    this.title = '',
    this.descripton = '',
    this.category = '',
    this.deadline = '',
    this.comments = const [],
    this.timeStamp,
    this.taskuid = '',
    this.uid = '',
    this.uploadedBy = '',
    this.isDone = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'descripton': descripton,
      'category': category,
      'deadline': deadline,
      'uploadedBy': uploadedBy,
      'isDone': isDone,
      'timeStamp': DateTime.now(),
      'comments': comments,
      'taskuid': taskuid,
    };
  }

  AddTask fromMap(Map<String, dynamic> map) {
    return AddTask(
      title: map['title'],
      descripton: map['descripton'],
      category: map['category'],
      deadline: map['deadline'],
      uploadedBy: map['uploadedBy'],
      isDone: map['isDone'],
      timeStamp: map['timeStamp'],
      comments: map['comments'],
      taskuid: map['taskuid'],
    );
  }
}

class Comments {
  List<dynamic> comments;
  String uid;
  Comments({
    this.comments = const [],
    this.uid = '',
  });
  Map<String, dynamic> toMap() {
    return {
      'myNetwork': comments,
    };
  }

  Comments fromMap(Map<String, dynamic>? mymap) {
    return Comments(comments: mymap!['comments']);
  }
}
