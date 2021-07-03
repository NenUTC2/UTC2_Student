import 'package:cloud_firestore/cloud_firestore.dart';

class FileDatabase {
  static getFileData(String idClass, String idPost) async {
    List<File> list = [];
    var data = await FirebaseFirestore.instance
        .collection('Class')
        .doc(idClass)
        .collection('Post')
        .doc(idPost)
        .collection('File')
        .get();
    list = data.docs.map((e) => File(e)).toList();
    return list;
  }
}

class File {
  String idPost, nameFile, url;
  String ref;
  File(QueryDocumentSnapshot<Map<String, dynamic>> json) {
    this.nameFile = json['name'];
    this.url = json['url'];
    this.idPost = json['idPost'];
    this.ref = json['ref'];
  }
}
