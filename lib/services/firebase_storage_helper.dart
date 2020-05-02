import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class FirebaseStorageHelper {
  BuildContext context;

  //For Upload
  FileType _pickingType = FileType.any;
  String _pathImage = "";

  //Constructor
  FirebaseStorageHelper(this.context, this._pathImage, this._pickingType);

  Container upload;

  //get a not uploaded widget
  Container getNoneSelected(double size, String headline2, String subTitle) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Card(
        color: myAppTheme.cardColor,
        margin: myAppTheme.cardTheme.margin,
        shape: myAppTheme.cardTheme.shape,
        elevation: 6,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                headline2,
                style: myAppTheme.textTheme.caption,
              ),
            ),
            Text(
              subTitle,
              style: myAppTheme.textTheme.body2,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                ),
                iconSize: MediaQuery.of(context).size.width * 0.2,
                onPressed: () {
                  _openFileExplorer().then((val) {
//                      setState(() => _pathImage = val);
                    _pathImage = val;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  //get a not uploaded widget
  Container getToUpload(double size, String headline2, String subTitle) {
    return Container(
      padding: EdgeInsets.all(5),
      child: Card(
        color: myAppTheme.cardColor,
        margin: myAppTheme.cardTheme.margin,
        shape: myAppTheme.cardTheme.shape,
        elevation: 6,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                headline2,
                style: myAppTheme.textTheme.caption,
              ),
            ),
            Text(
              subTitle,
              style: myAppTheme.textTheme.body2,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: IconButton(
                icon: Icon(
                  Icons.add_circle_outline,
                  color: Colors.grey,
                ),
                iconSize: MediaQuery.of(context).size.width * 0.2,
                onPressed: () {
                  _openFileExplorer().then((val) {
//                      setState(() => _pathImage = val);
                    _pathImage = val;
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  //Get an Uploaded widget
  Container getUploaded(double size, String headline2) {
    String subTitle = "";
    subTitle = _pathImage.contains("http://") || _pathImage.contains("https://") ? "Uploaded File" : "Selected: " + _pathImage.split('/').last;
    return Container(
      padding: EdgeInsets.all(5),
      child: Card(
        color: myAppTheme.cardColor,
        margin: myAppTheme.cardTheme.margin,
        shape: myAppTheme.cardTheme.shape,
        elevation: 6,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                headline2,
                style: myAppTheme.textTheme.caption,
              ),
            ),
            Text(
              subTitle,
              style: myAppTheme.textTheme.body2,
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: InkWell(
                  child: _pathImage.contains("http://") || _pathImage.contains("https://")
                      ? Image.network(
                          _pathImage,
                          width: 100,
                          height: 100,
                        )
                      : Image.file(
                          File(_pathImage),
                          width: 100,
                          height: 100,
                        ),
                  onTap: () {
                    _openFileExplorer().then((val) {
//                      setState(() => _pathImage = val);
                      _pathImage = val;
                    });
                  }),
            )
          ],
        ),
      ),
    );
  }

  //Uploads the documents to Firebase Storage to the given path
  Future<String> uploadDocuments(String filename, String fileExt) async {
    final StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child("" + "/" + filename + "." + fileExt).putFile(File(_pathImage));
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    return uploadTask.isSuccessful ? url : null;
  }

  Future<String> _openFileExplorer() async {
    String _path = "";
    try {
      _path = await FilePicker.getFilePath(type: _pickingType);
    } catch (e) {
      print("Unsupported operation" + e.toString());
    }
    return _path;
  }
}
