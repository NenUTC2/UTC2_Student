import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:flutter/material.dart';
import 'package:utc2_student/models/firebase_file.dart';
import 'package:utc2_student/service/firestore/api_getfile.dart';
import 'package:utc2_student/service/firestore/api_upfile.dart';
import 'package:utc2_student/utils/utils.dart';

class NewFile extends StatefulWidget {
  final String idClass;

  const NewFile({Key key, this.idClass}) : super(key: key);
  @override
  _NewFileState createState() => _NewFileState();
}

class _NewFileState extends State<NewFile> {
  UploadTask task;
  List<bool> listSelect = [];
  File file;
  List<FirebaseFile> listUpload = [];
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file.path);
    final destination = '${widget.idClass}/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

   
    setState(() {
      listUpload.add(FirebaseFile(
          ref: snapshot.ref, name: snapshot.ref.name, url: urlDownload));
      listSelect.add(true);
    
    });
  }

  Widget buildUploadStatus(UploadTask task, String fileName, Size size) =>
      StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Container(
              padding: EdgeInsets.all(10),
              width: size.width,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(
                      stops: [0.1, (double.parse(percentage) / 100)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [ColorApp.mediumOrange, ColorApp.lightOrange])),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      fileName,
                      softWrap: true,
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    '$percentage %',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ),
            );
          } else {
            return Container(
              child: Center(
                  child: SpinKitThreeBounce(
                color: Colors.lightBlue,
                size: 20,
              )),
            );
          }
        },
      );
  Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    super.initState();
    futureFiles = FirebaseApiGetFile.listAll('files/');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final fileName = file != null ? basename(file.path) : '';
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            color: ColorApp.lightGrey,
            onPressed: () {
              for (var item in listUpload) {
                FirebaseStorage.instance
                    .ref()
                    .child('${widget.idClass}/${item.name}')
                    .delete();
              }
              Get.back();
            },
            icon: Icon(
              Icons.close_rounded,
              color: ColorApp.black,
            ),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Tệp đính kèm',
            style: TextStyle(color: ColorApp.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                List<FirebaseFile> list = [];
                for (int i = 0; i < listUpload.length; i++) {
                  if (listSelect[i])
                    list.add(listUpload[i]);
                  else
                    FirebaseStorage.instance
                        .ref()
                        .child('${widget.idClass}/${listUpload[i].name}')
                        .delete();
                }
                Get.back(result: list);
              },
              child: Text("Thêm    ",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            )
          ],
        ),
        body: Container(
            height: size.height,
            width: size.width,
            padding: EdgeInsets.all(size.width * 0.03),
            decoration: BoxDecoration(color: Colors.white),
            child: Column(children: [
              task != null
                  ? buildUploadStatus(task, fileName, size)
                  : Container(),
              Container(
                width: size.width,
                child: TextButton.icon(
                  onPressed: () {
                    selectFile().whenComplete(() {
                      uploadFile();
                    });
                  },
                  label: Text(
                    'Chọn file',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  icon: Icon(
                    Icons.attachment,
                    size: 14,
                  ),
                  style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.padded,
                      shadowColor:
                          MaterialStateProperty.all<Color>(Colors.lightBlue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.blue)))),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(listUpload.length),
                    SizedBox(height: 12),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          futureFiles =
                              FirebaseApiGetFile.listAll('${widget.idClass}/');
                        },
                        child: ListView.builder(
                          itemCount: listUpload.length,
                          itemBuilder: (context, index) {
                            final file = listUpload[index];

                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                      stops: [0.08, 1],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.white,
                                        ColorApp.lightGrey
                                      ])),
                              child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Checkbox(
                                      value: listSelect[index],
                                      activeColor: ColorApp.mediumOrange,
                                      checkColor: Colors.white,
                                      shape: CircleBorder(),
                                      onChanged: (value) {
                                        setState(() {
                                          listSelect[index] = value;
                                        });
                                      },
                                    ),
                                    isImage(file.name)
                                        ? CircleAvatar(
                                            backgroundColor:
                                                ColorApp.lightGrey,
                                            radius: 15,
                                            backgroundImage:
                                                CachedNetworkImageProvider(
                                                    file.url),
                                          )
                                        : Container(),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.centerLeft,
                                        // height: 25,
                                        child: Text(
                                          file.name,
                                        ),
                                      ),
                                    )
                                  ]),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ])));
  }

  Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
        leading: ClipOval(
          child: Image.network(
            file.url,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          file.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
            color: Colors.blue,
          ),
        ),
        onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => null,
        )),
      );

  Widget buildHeader(int length) => ListTile(
        tileColor: Colors.blue,
        leading: Container(
          width: 40,
          height: 40,
          child: Icon(
            Icons.file_copy,
            color: Colors.black,
          ),
        ),
        title: Text(
          '$length Files',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
            color: Colors.black,
          ),
        ),
      );
}
