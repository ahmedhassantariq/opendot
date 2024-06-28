import 'package:reddit_app/models/postFileModel.dart';

class Constants {




  checkType(url){
    String postType = "post";
    if(url!=null) {

      switch (url.toLowerCase()) {
        case "png":
          postType = "image";
          break;
        case "jpg":
          postType = "image";
          break;
        case "jpeg":
          postType = "image";
          break;
        case "mp4":
          postType = "video";
          break;
        case "mov":
          postType = "video";
          break;
        case "mp3":
          postType = "video";
          break;
        case "wav":
          postType = "video";
          break;



        default:
          postType = "file";
      }
    }
    return postType;
  }
}