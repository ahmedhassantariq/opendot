import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reddit_app/services/posts/post_services.dart';

import '../../components/postTextfield.dart';
class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final TextEditingController _postTextFieldTitleController = TextEditingController();
  final TextEditingController _postTextFieldBodyController = TextEditingController();
  late final PostServices _postServices = PostServices();
  final ImagePicker picker = ImagePicker();
  late List<String> imageUrl = [];
  double iconSize = 30;
  bool isUploading = false;
  double uploadProgress = 0;
  bool pause = false;
  bool cancel = false;

  checkType(){
    String postType = "post";
    if(imageUrl.isNotEmpty) {
      String s = imageUrl.first;
      String one = s.substring(s.indexOf("/images%"), s.indexOf("?"));
      String two = one.substring(one.indexOf("."));
      switch (two) {
        case ".png":
          postType = "image";
          break;
        case ".jpg":
          postType = "image";
          break;
        case ".jpeg":
          postType = "image";
          break;
        case ".mp4":
          postType = "video";
          break;
        case ".mov":
          postType = "video";
          break;
        case ".mp3":
          postType = "video";
          break;
        case ".wav":
          postType = "video";
          break;
        default:
          postType = "file";
      }
    }
    return postType;
  }

  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height-76,
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: (){Navigator.pop(context);},
                        focusColor: Colors.transparent,
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        icon: const Icon(Icons.close)),
                    !isUploading ? TextButton(
                      onPressed: (){
                        checkType();
                        if(_postTextFieldTitleController.text.isNotEmpty){
                          _postServices.createPost(
                              _postTextFieldTitleController.text,
                              _postTextFieldBodyController.text,
                              imageUrl,
                            checkType()
                          );
                          Navigator.pop(context);
                          Provider.of<PostServices>(context, listen: false).notifyListeners();
                          _postTextFieldTitleController.clear();
                          _postTextFieldBodyController.clear();
                        }
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(75, 50),
                          backgroundColor: MaterialStateColor.resolveWith((states) => Colors.blue),
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                          )
                      ),
                      child: const Text("Post", style: TextStyle(color: Colors.white),),
                    ):
                    GestureDetector(onTap: (){cancel=true;},child: const Icon(Icons.stop, color: Colors.red,size: 50,)),
                  ],
                ),
              ),
              PostTextField(controller: _postTextFieldTitleController, hintText: "Title", obscureText: false, fontWeight: FontWeight.w600,fontSize: 18,),
              PostTextField(controller: _postTextFieldBodyController, hintText: "Body", obscureText: false, fontSize: 16,),
              for(int i=0;i<imageUrl.length;i++)
                imageUrl.isNotEmpty ?
                Container(
                  alignment: Alignment.center,child:
                Column(
                  children: [
                    IconButton(onPressed: (){
                      setState(() {
                        imageUrl.removeWhere((element) => element==imageUrl[i]);
                      });
                      }, icon: const Icon(Icons.delete_outline)),
                    checkType()=="image"  ?
                    CachedNetworkImage(imageUrl: imageUrl[i],placeholder: (context, url) => const CircularProgressIndicator(), errorWidget: (context, url, error) => const Icon(Icons.image_not_supported_outlined)):
                    const Icon(Icons.video_library_outlined)
                    ,

                  ],
                ))
                  :const SizedBox(width: 0,height: 0,),
            ],
          ),
        ),
        isUploading ? LinearProgressIndicator(value: uploadProgress) : const SizedBox(width:0,height: 0,),
        Container(
          height: 56,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.keyboard, color: Colors.grey, size: iconSize),
                const SizedBox(width: 8.0,),
                Icon(Icons.add_link, color: Colors.grey, size: iconSize),
                const SizedBox(width: 8.0,),
                Icon(Icons.gif_box_outlined, color: Colors.grey, size: iconSize),
                const SizedBox(width: 8.0,),
                GestureDetector(
                    onTap: () async {
                      // final pickedImage = await picker.pickImage(source: ImageSource.gallery, imageQuality: 0);
                      FilePickerResult? pickedImage = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                      );
                      if(pickedImage!=null) {
                        PlatformFile file = pickedImage.files.first;
                        // File file = File(pickedImage!.path);
                        // Image image = Image.memory(await pickedImage.readAsBytes());
                        Uint8List? img = pickedImage.files.single.bytes;
                        setState(() {
                          isUploading = true;
                        });
                        final storageReference = FirebaseStorage.instance.ref();
                        final uploadTask = storageReference.child('images/${pickedImage.files.single.name}').putData(img!);
                        uploadTask.snapshotEvents.listen((TaskSnapshot taskSnapshot) {
                          switch (taskSnapshot.state) {
                            case TaskState.running:
                               setState(() {
                                 uploadProgress = (taskSnapshot.bytesTransferred / taskSnapshot.totalBytes);
                                 if(cancel){
                                   uploadTask.cancel();
                                   setState(() {
                                     isUploading = false;
                                     cancel = false;
                                   });
                                 }
                               });
                              break;
                            case TaskState.paused:
                              break;
                            case TaskState.canceled:
                              print("Upload was canceled");
                              break;
                            case TaskState.error:
                              setState(() {
                                isUploading = false;
                              });
                              break;
                            case TaskState.success:
                              _postServices.getUrl(pickedImage.files.single.name).then((value){imageUrl.add(value);
                              setState(() {
                                isUploading = false;
                              });});
                              break;
                          }
                        });


                      }
                    },
                    child: const Icon(Icons.photo_outlined, color: Colors.grey))
              ],
            ),
          ),
        )
      ],
    );
  }
  }
