import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as ui;
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:untitled/black.dart';
class crop extends StatefulWidget {
  final image;
  final ip;
  crop(this.image,this.ip);
  @override
  State<crop> createState() => _cropState(image,ip);
}

class _cropState extends State<crop> {
  late File white;
  var _imageFile;
  final IP;
  bool black=false;
  _cropState(this._imageFile,this.IP);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: [IconButton(onPressed: (){
        Navigator.push(context,MaterialPageRoute(builder: (context) => blacks(_imageFile,IP)));
      }, icon: Icon(Icons.done_outline,color: Colors.blue,))],
      ),
      body:Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_imageFile != null) ...[
             Image.file(
               _imageFile,
    width: 400,
      height: 600,
    ),TextButton.icon(onPressed: () async{
                await imageCropperView(_imageFile,context);
              }, icon: Icon(Icons.crop),label: Text("Crop")),
            ] else ...[
              Text('No image selected.'),
            ]
          ],
        ),
      ),
    );
  }
 imageCropperView(File ff, BuildContext context) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: ff.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Crop Image',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      log("image cropped");
      // ignore: use_build_context_synchronously
setState(() {
  _imageFile=File(croppedFile.path);
});
    } else {
      log("user do nothing");
      return '';
    }
  }


}
