import 'dart:io';
import 'package:pdf_render/pdf_render.dart';
import 'package:document_scanner_flutter/document_scanner_flutter.dart';
import 'package:document_scanner_flutter/configs/configs.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:untitled/IP.dart';
import 'newplash.dart';
import 'splash.dart';
import 'imageview.dart';
import 'package:image/image.dart' as img;
import 'package:file_picker/file_picker.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
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

  openImageScanner(BuildContext context, String IP) async {
    var image = await DocumentScannerFlutter.launch(IP,context
        //source: ScannerFileSource.CAMERA,
        ,labelsConfig: {
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
        title: Text("Arabic OCR"),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ip(IP,Done)));
          }, icon: Icon(Icons.settings))
        ],
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
                    color: Colors.grey
                ),
                child: Center(child: Text("Recent Document",
                  style: TextStyle(fontSize: 23,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),))) :
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => openImageScanner(context, IP),
        child: Icon(Icons.camera_alt_outlined),
      ),
    ));
  }
}