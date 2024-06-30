import "package:universal_html/html.dart";
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_downloader/flutter_file_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reddit_app/components/CONSTANTS.dart';
import 'package:reddit_app/components/postImagePreview.dart';
import 'package:reddit_app/components/videoViewer.dart';
import 'package:flutter/src/widgets/text.dart' as written_text;
import '../models/postFileModel.dart';

class PostFileIcon extends StatelessWidget {
  final Map<String, dynamic> url;

  const PostFileIcon({
    super.key,
    required this.url});



  void download(String url, String title) async {
    String path = await _getFilePath(title);
    var status = await Permission.storage.request().then((value) async {
      if (value.isGranted) {
        try{
          FileDownloader.downloadFile(
              url: url,
              name: title,
              downloadDestination: DownloadDestinations.publicDownloads,
              onProgress: (process, value){

              },
              onDownloadCompleted: (completed){

              },
              onDownloadError: (e){

              }
          );
        }catch(e){
        }

      } else if (value.isDenied) {
        print("Permission Denied");
      } else {
        print("Error Occurred");
      }
    });
  }

  Future<String> _getFilePath(String filename) async {
    Directory? dir;

    try {
      if (defaultTargetPlatform==TargetPlatform.iOS) {
        dir = await getApplicationDocumentsDirectory(); // for iOS
      } else {
        dir = Directory('/storage/emulated/0/Download/');  // for android
        if (!await dir.exists()) dir = (await getExternalStorageDirectory())!;
      }
    } catch (err) {
      print("Cannot get download folder path $err");
    }
    return "${dir?.path}$filename";
  }

  downloadFile(String url) async {
    AnchorElement anchorElement =  AnchorElement(href: url);
    anchorElement.download = url;
    anchorElement.click();

  }


  @override
  Widget build(BuildContext context) {
      final model  = PostFileModel.fromJson(url);
      final type = Constants().checkType(model.extension);
    if(type=='image'){
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
          child: PostImagePreview(url: model.url));
    }
    if(type=='video'){
      return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(8.0)),
          child: VideoViewer(url: model.url));
    }
    if(type=='file'){
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.attach_file),
            written_text.Text(model.name.toString()),
            IconButton(onPressed: (){
              if(defaultTargetPlatform==TargetPlatform.android) {
                download(model.url, model.name);
              }
              if(kIsWeb){
                print("Web");
                downloadFile(model.url);
              }
            }, icon: const Icon(Icons.download))
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
