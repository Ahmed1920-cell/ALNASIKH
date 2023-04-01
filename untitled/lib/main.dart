import 'dart:io';
import 'package:pdf_render/pdf_render.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:ALNASIKH/IP.dart';
import 'newplash.dart';
import 'imageview.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';

import 'dart:ui' as ui;
import 'package:ALNASIKH/crop.dart';
Future<File?> pickPdfFile() async {
  final result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );

  if (result != null) {
    print("upload");
    return File(result.files.single.path!);
  } else {
    // User canceled the picker
    return null;
  }
}
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: splashScreen(),
      //home: ip(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  final ip;
  final done;
  final pdf_path;

  MyHomePage(this.ip, this.done, this.pdf_path);

  State<MyHomePage> createState() => _MyHomePageState(ip, done, pdf_path);
}

class _MyHomePageState extends State<MyHomePage> {
  final IP;
  final Done;
  final pdf_path;

  _MyHomePageState(this.IP, this.Done, this.pdf_path);

  bool isCamera = false;
  double r = 0;
  File? _scannedImage;
  Future<File?> pickPdfFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      return File(result.files.single.path!);
    } else {
      // User canceled the picker
      return null;
    }
  }
  openCameraScanner(BuildContext context, String IP) async {
    var image = await DocumentScannerFlutter.launch(IP,context,
        source: ScannerFileSource.CAMERA,
        labelsConfig: {
          ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
          ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
        });
    if (image != null) {
      print("jjjjjjjjjjjjjjjjjjj");
      print(image);
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => imageView(imagePath: image, ip: IP,)));
      //_scannedImage = image;
      setState(() {
        _scannedImage = image;
      });
    }
  }
  openGalleryScanner(BuildContext context, String IP) async {
    var image = await DocumentScannerFlutter.launch(IP,context,
        source: ScannerFileSource.GALLERY,
        labelsConfig: {
          ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
          ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
        });
    if (image != null) {
      print("jjjjjjjjjjjjjjjjjjj");
      print(image);
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context) => imageView(imagePath: image, ip: IP,)));
      //_scannedImage = image;
      setState(() {
        _scannedImage = image;
      });
    }
  }


  /*void onCameraTap() {
    log("Camera");
    // pickImage(source: ImageSource.camera).then((path) {
    //   if (path != '') {
    //     imageCropperView(path, context).then((value) => {
    //       if (value != '')
    //         {
    //           Navigator.push(
    //             context,
    //             CupertinoPageRoute(
    //               builder: (_) => RecognizePage(
    //                 path: value,
    //               ),
    //             ),
    //           ),
    //         }
    //     });
    //   }
    // });
  }*/

/*  void onGallaryTap() {
    log("Gallary");
    // pickImage(source: ImageSource.gallery).then((path) {
    //   if (path != '') {
    //     galleryObject(path);
    //   }
    // });
  }*/

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child:
    Scaffold(
      appBar: AppBar(
        title: Text("ALNASIKH APP"),
      ),
      body: Container(
        color: Colors.black,
        height: double.infinity,
        //alignment: Alignment.center,
        child: Column(
          children: [
           !Done ?Container(
                width: double.infinity,
                height: 580,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    //color: Colors.grey
                ),
                child: Center(child: Text("Recent Documents",
                  style: TextStyle(fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Colors.white),))) :
                Container(
                  padding: EdgeInsets.all(8),
                  width: double.infinity
                  ,child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                          radius: 29
                          ,backgroundImage:AssetImage("assets/PDF.png")),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Expanded(
                          flex: 2,
                          child: Container(child: Text("1",style: TextStyle(fontSize: 17,color: Colors.white,fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      Expanded(flex: 1,child: TextButton(onPressed:(){
                        OpenFile.open(pdf_path);
                      },child: Text("View pdf")
                  ))],
                ),
                ),
            ),
          ],
        ),
      ),
     /* floatingActionButton: FloatingActionButton(
        onPressed: () => openImageScanner(context, IP),
        child: Icon(Icons.camera_alt_outlined)),*/
      floatingActionButton: FabCircularMenu(
          alignment: Alignment.bottomRight,
          ringColor: Colors.blue.withAlpha(25),
          ringDiameter: 400.0,
          ringWidth: 100.0,
          fabSize: 60.0,
          fabElevation: 8.0,
          fabIconBorder: CircleBorder(),
          children: <Widget>[
            RawMaterialButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ip(IP,Done)));
              },
              elevation: 10.0,
              fillColor: Colors.green,
              child: Icon(
                Icons.settings,
                size: 30.0,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            ),
            RawMaterialButton(
              onPressed: () async {
                final path=await pickPdfFile();

                if(path!=null){
                  final doc = await PdfDocument.openFile(path.path);
                  PdfPage  page = await doc.getPage(1);
                  PdfPageImage  pageImage = await page.render(
                    width: page.width.toInt(),
                    height: page.height.toInt(),
                  );
                  //final image=img.Image.fromBytes(width: page.width.toInt(), height: page.height.toInt(), bytes: pageImage.imageIfAvailable)
                  //final imageWidget = pageImage.pixels;
                  await pageImage.createImageIfNotAvailable();
                  var image=pageImage.imageIfAvailable;
                  if(image!=null){
                    final directory = await getApplicationDocumentsDirectory();
                    final imagePath = '${directory.path}/my_image.jpg';

                    ByteData? imageBytes = await image.toByteData(format: ui.ImageByteFormat.png);
                    if(imageBytes!=null){
                      final compressedImageBytes = await FlutterImageCompress.compressWithList(
                        imageBytes.buffer.asUint8List(),
                        minHeight: 800,
                        minWidth: 800,
                      );

                      final file = File(imagePath);
                      await file.writeAsBytes(compressedImageBytes);
                      print("MMMMMMMMMMMMMMMMMMMMMMMMMM");
                      print(file.path);
                      //Navigator.push(context,MaterialPageRoute(builder: (context) => imageView(imagePath:file,ip:IP)));
                      Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => crop(file,IP)));
                    }
                  }
                  //print(pageImage.imageIfAvailable.toByteData(format: ImageByteFormat.rawRgba));
                  //Navigator.push(context,MaterialPageRoute(builder: (context) => imageView(imagePath:pageImage.imageIfAvailable,ip:IP)));
                  // print(imageWidget);
                  print(path.path);}
                //return RawImage(image: pageImage.imageIfAvailable, fit: BoxFit.contain);
                //await pageImage.writeAsBytes(File('path/to/image/file').readAsBytesSync());
                //imageView(imagePath:imageFile.path,ip:"192.168.1.1");
                print(path);
              },
              elevation: 10.0,
              fillColor: Colors.orange,
              child: Icon(
                Icons.picture_as_pdf,
                size: 30.0,
              ),
              padding: EdgeInsets.all(15.0),
              shape: CircleBorder(),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.purple,
              child: IconButton(
                  icon: Icon(
                    Icons.photo_library_sharp,
                    size: 30,
                  ),
                  onPressed: () {
                    openGalleryScanner(context, IP);
                  }),
            ),
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.deepOrange,
              child: IconButton(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    openCameraScanner(context, IP);
                  }),
            ),
          ]),
      ),
    );
  }
}