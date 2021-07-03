import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:utc2_student/models/firebase_file.dart';
import 'package:utc2_student/service/firestore/api_getfile.dart';
import 'package:utc2_student/utils/utils.dart';

class ImagePage extends StatelessWidget {
  final FirebaseFile file;

  const ImagePage({Key key, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(file.name),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () async {
              await FirebaseApiGetFile.downloadFile(
                  file.url, file.name, context);
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: isImage(file.name)
          ? PhotoView(
              imageProvider: CachedNetworkImageProvider(file.url),
            )
          : Center(
              child: Text(
                'Cannot be displayed',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
