import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

import 'main.dart';

class imageView extends StatefulWidget {
  imageView({super.key, required this.imagePath, required this.ip});

  final imagePath;
  final ip;
  @override
  State<imageView> createState() => _imageViewState(imagePath, ip);
}

class _imageViewState extends State<imageView> {
  _imageViewState(this.imageFile, this.IP);
  bool done=false;
String pdf_path="";
  var IP;
  double font=18;
  var chr = "";
  int n = 0;
  final imageFile;
  bool NotCopy = true;
  ocr() async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("https://f6d3-102-41-166-33.eu.ngrok.io/to_detection");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.headers.addAll({"ngrok-skip-browser-warning": "0"});
    request.files.add(multipartFile);
    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) async {
      var str = "";
      for (int i = 0; i < int.parse(value); i++) {
        final res =
            await http.get(Uri.parse("https://f6d3-102-41-166-33.eu.ngrok.io/to_ocr?number=$i"),headers:{"ngrok-skip-browser-warning": "0"});
        if (res.statusCode == 200) {
          str = str + res.body;
          setState(() {
            chr = str;
          });
        }
      }
      setState(() {
        NotCopy = false;
      });
      print(str);
    });
  }
  @override
  Widget build(BuildContext context) {
    if (n == 0) ocr();
    n++;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          appBar: AppBar(
           // backgroundColor: Color.fromRGBO(13, 64, 181, 1),
            title: Text('OCR Output'),
            elevation: 0,

          ),
          body: Container(
            color: Colors.black,
            child: Center(
              child: SingleChildScrollView(
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    //color: Colors.red,
                    height: 200,
                    width: 400,
                    child:InteractiveViewer(
                      panEnabled: false, // Set it to false
                    // boundaryMargin: EdgeInsets.all(100),
                      minScale: 1,
                      maxScale: 4,
                      child: Image.file(
                        imageFile,
                        height: 200,
                        width: 400,
                        //fit: BoxFit.cover,
                      ),
                    ),
                    //RawImage(image: imageFile, fit: BoxFit.contain)
                    //imageFile
                    //Image(image: MemoryImage(imageFile),)
                  ),
                  Container(
                    decoration: BoxDecoration(
                      //border:Border.all(color: Colors.grey,width: 5),
                      borderRadius: BorderRadius.circular(25),
                      color: chr==""?null:Color.fromRGBO(141, 160, 186, 0.5),
                       //Colors.grey.withOpacity(0.3)
                    ),
                    child: chr==""?CircularProgressIndicator():Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SelectableText(chr,
                              style: TextStyle(fontSize: font, color: Colors.white,fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,textDirection: TextDirection.rtl,),
                        ),
                        if (!NotCopy)  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              style: NotCopy
                                  ? ButtonStyle(
                                  backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey))
                                  : ButtonStyle(
                                  backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue)),
                              onPressed: NotCopy?(){}:() {
                                Clipboard.setData(ClipboardData(text: chr));
                              },
                              icon: Icon(Icons.copy,color: Colors.white,),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                              style: NotCopy
                                  ? ButtonStyle(
                                  backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey))
                                  : ButtonStyle(
                                  backgroundColor:
                                  MaterialStatePropertyAll(Colors.blue)),
                              onPressed: NotCopy?(){}:() async {
                                //var tempDir = await getTemporaryDirectory();
                                var tempDir=Directory((Platform.isAndroid
                                    ? await getExternalStorageDirectory() //FOR ANDROID
                                    : await getApplicationSupportDirectory() //FOR IOS
                                )!
                                    .path + '/recent');
                                var status = await Permission.storage.status;
                                if (!status.isGranted) {
                                  await Permission.storage.request();
                                }
                                if ((await tempDir.exists())) {
                                  print("is exist");
                                } else {
                                  tempDir.create(recursive: true);
                                  print("is create");
                                }
                                await download(Dio(), "https://f6d3-102-41-166-33.eu.ngrok.io/return_PDF",
                                    tempDir.path + "/aaa.pdf");
                              },
                              icon: Image.asset("assets/landing-pdf-converter.png",width: 150,height: 150,),),
                          ],
                        ) ,
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (font > 12) {
                              font -= 1;
                            }
                          });
                        },
                        child: Icon(Icons.remove, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: font>12&&!NotCopy?Colors.blue:Colors.grey
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (font < 26) {
                              font += 1;
                            }
                          });
                        },
                        child: Icon(Icons.add, color: Colors.white),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                            backgroundColor: font<26&&!NotCopy?Colors.blue:Colors.grey
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: NotCopy
                ?Colors.grey:Colors.green,
              onPressed: NotCopy?(){}:() {
                Navigator.push(context, MaterialPageRoute(builder: (_){
                  return MyHomePage(IP,done,pdf_path);
                }));
              },
              child: Icon(Icons.done_outline,
              color: Colors.black,))
          ),
        );
  }

  double progress = 0;

  // Track if the PDF was downloaded here.
  bool didDownloadPDF = false;

  // Show the progress status to the user.
  String progressString = 'File has not been downloaded yet.';

  void updateProgress(done, total) {
    progress = done / total;
    setState(() {
      if (progress >= 1) {
        progressString =
            '✅ File has finished downloading. Try opening the file.';
        didDownloadPDF = true;
      } else {
        progressString = 'Download progress: ' +
            (progress * 100).toStringAsFixed(0) +
            '% done.';
      }
    });
  }

  Future download(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: updateProgress,
        options: Options(
          headers: {"ngrok-skip-browser-warning": "0"},
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      var file = File(savePath).openSync(mode: FileMode.write);
      print(savePath);
      file.writeFromSync(response.data);
      OpenFile.open(savePath);
      setState(() {
        done=true;
        pdf_path=savePath;
      });
      // Here, you're catching an error and printing it. For production
      // apps, you should display the warning to the user and give them a
      // way to restart the download.
    } catch (e) {
      print(e);
    }
  }
}
