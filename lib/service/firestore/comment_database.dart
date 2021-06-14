import 'package:cloud_firestore/cloud_firestore.dart';

class CommentDatabase {
  Future<void> createComment(Map<String, String> dataComment, String idClass,
      String idPost, String idComment) async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('Comment')
        .doc(idComment)
        .set(dataComment);
  }

  Future<void> deleteComment(
      String idClass, String idPost, String idComment) async {
    await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('Comment')
        .doc(idComment)
        .delete();
  }

  static getCommentData(String idClass, String idPost) async {
    List<Comment> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('Comment')
        .get();
    print(data.docs.length);
    list = data.docs.map((e) => Comment(e)).toList();
    print(
        list.length.toString() + '------Bị nulll đây ta---------------------');
    return list;
  }
}

class Comment {
  String idComment, idClass, idPost, content, date, name, avatar;
  Comment(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.idComment = json['id'];
    this.idClass = json['idClass'];
    this.idPost = json['idPost'];
    this.content = json['content'];
    this.date = json['date'];
    this.name = json['name'];
    this.avatar = json['avatar'];
  }
}
