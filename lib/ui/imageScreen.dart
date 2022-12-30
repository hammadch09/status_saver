import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'viewphotos.dart';

final Directory _newPhotoDir = Directory(
    '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
final Directory _oldPhotoDir =
    Directory('/storage/emulated/0/WhatsApp/Media/.Statuses');

class ImageScreen extends StatefulWidget {
  const ImageScreen({Key? key}) : super(key: key);

  @override
  ImageScreenState createState() => ImageScreenState();
}

class ImageScreenState extends State<ImageScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!Directory('${_newPhotoDir.path}').existsSync() &&
        !Directory('${_oldPhotoDir.path}').existsSync()) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Install WhatsApp\n',
            style: TextStyle(fontSize: 18.0),
          ),
          const Text(
            "Your Friend's Status Will Be Available Here",
            style: TextStyle(fontSize: 18.0),
          ),
        ],
      );
    } else {
      var imageList;
      if (Directory('${_newPhotoDir.path}').existsSync()) {
        imageList = _newPhotoDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.jpg'))
            .toList(growable: false);
      } else {
        imageList = _oldPhotoDir
            .listSync()
            .map((item) => item.path)
            .where((item) => item.endsWith('.jpg'))
            .toList(growable: false);
      }
      if (imageList.length > 0) {
        return Container(
            margin: const EdgeInsets.all(8.0),
            child: GridView.builder(
              key: PageStorageKey(widget.key),
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 250,
              ),
              itemCount: imageList.length,
              itemBuilder: (BuildContext context, int index) {
                final String imgPath = imageList[index];
                return Container(
                  padding: const EdgeInsets.all(1.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewPhotos(
                            imgPath: imgPath,
                          ),
                        ),
                      );
                    },
                    child: Image.file(
                      File(imageList[index]),
                      fit: BoxFit.cover,
                      filterQuality: FilterQuality.medium,
                    ),
                  ),
                );
              },
            )
            // child: StaggeredGrid.count(
            //   crossAxisCount: 4,
            //   mainAxisSpacing: 8.0,
            //   crossAxisSpacing: 8.0,
            //   // crossAxisSpacing: 4,
            //   children: [
            //     ...imageList.map((imgPath) => StaggeredGridTile.count(
            //           crossAxisCellCount: 2,
            //           mainAxisCellCount:
            //               imageList.indexOf(imgPath).isEven ? 2 : 3,
            //           child: Material(
            //             elevation: 8.0,
            //             borderRadius: const BorderRadius.all(Radius.circular(8)),
            //             child: InkWell(
            //               onTap: () {
            //                 Navigator.push(
            //                   context,
            //                   MaterialPageRoute(
            //                     builder: (context) => ViewPhotos(
            //                       imgPath: imgPath,
            //                     ),
            //                   ),
            //                 );
            //               },
            //               child: Hero(
            //                   tag: imgPath,
            //                   child: Image.file(
            //                     File(imgPath),
            //                     fit: BoxFit.cover,
            //                   )),
            //             ),
            //           ),
            //         ))
            //   ],
            // ),
            );
      } else {
        return Scaffold(
          body: Center(
            child: Container(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: const Text(
                  'Sorry, No Image Found!',
                  style: TextStyle(fontSize: 18.0),
                )),
          ),
        );
      }
    }
  }
}
