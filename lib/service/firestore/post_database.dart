import 'package:cloud_firestore/cloud_firestore.dart';

class PostDatabase {
  Future<void> createPost(
      Map<String, String> dataPost, String idClass, String idPost) async {
    print(idClass);
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .set(dataPost);
  }

  // Future<void> deleteClass(String id) async {
  //   await FirebaseFirestore.instance.collection('Class').doc(id).delete();
  // }

  getClassData(String idClass) async {
    List<Post> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .get();
    list = data.docs.map((e) => Post(e)).toList();
    return list;
  }
}

class Post {
  String id, idClass, title, content, date, name, avatar;
  List file;

  Post(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.id = json['id'];
    this.idClass = json['idClass'];
    this.title = json['title'];
    this.content = json['content'];
    this.date = json['date'];
    this.name = json['name'];
    this.avatar = json['avatar'];
  }
}

class Comment {
  String id, idPost, comment, time;
}

class File {
  String id, idPost, title;
}

class Quiz {
  String id, idPost, ques, correct, o1, o2, o3;
}
