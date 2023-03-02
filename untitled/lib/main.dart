import 'dart:io';

import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:flutter/material.dart';
import 'package:untitled/IP.dart';
import 'newplash.dart';
import 'splash.dart';
import 'imageview.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

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
  MyHomePage(this.ip);
  State<MyHomePage> createState() => _MyHomePageState(ip);
}

class _MyHomePageState extends State<MyHomePage> {
  final IP;
  _MyHomePageState(this.IP);
  bool isCamera = false;
  double r=0;
  File? _scannedImage;
  openImageScanner(BuildContext context,String IP) async {
    var image = await DocumentScannerFlutter.launch(context,
        //source: ScannerFileSource.CAMERA,
        labelsConfig: {
          ScannerLabelsConfig.ANDROID_NEXT_BUTTON_LABEL: "Next Step",
          ScannerLabelsConfig.ANDROID_OK_LABEL: "OK"
        });
    if (image != null) {
      print("jjjjjjjjjjjjjjjjjjj");
      print(image);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => imageView(imagePath: image,ip: IP,)));
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
        title: Text("Arabic OCR"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ip(IP)));
          }, icon: Icon(Icons.settings))
        ],
      ),
      body: Container(
        color: Colors.black,
        alignment: Alignment.center,
        child: Container(
            width: double.infinity,
            height: 580,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey
            ),
            child: Center(child: Text("Recent Document",style: TextStyle(fontSize: 23, fontWeight: FontWeight.w500,color: Colors.black),))
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openImageScanner(context,IP),
        child: Icon(Icons.camera_alt_outlined),
      ),
    ));
  }}