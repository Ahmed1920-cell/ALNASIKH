import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
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
  final IP;
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
    var uri = Uri.parse("http://$IP:5000/to_detection");

    // create multipart request
    var request = new http.MultipartRequest("POST", uri);

    // multipart that takes file
    var multipartFile = new http.MultipartFile('file', stream, length,
        filename: basename(imageFile.path));

    // add file to multipart
    request.files.add(multipartFile);

    // send
    var response = await request.send();
    print(response.statusCode);

    // listen for response
    response.stream.transform(utf8.decoder).listen((value) async {
      var str = "";
      for (int i = 0; i < int.parse(value); i++) {
        final res =
            await http.get(Uri.parse("http://$IP:5000/to_ocr?number=$i"));
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
            title: Text('image view'),
          ),
          body: Container(
            color: Colors.black,
            child: Center(
              child: SingleChildScrollView(
                child: Column(children: [
                  Image.file(
                    imageFile,
                    width: 400,
                    height: 400,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      //border:Border.all(color: Colors.grey,width: 5),
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(chr,
                          style: TextStyle(fontSize: 25, color: Colors.black,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
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
                          child: Text("Copy",
                              style: TextStyle(color: Colors.white))),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: NotCopy
                              ? ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.grey))
                              : ButtonStyle(
                                  backgroundColor:
                                      MaterialStatePropertyAll(Colors.blue)),
                          onPressed: NotCopy?(){}:() async {
                            var tempDir = await getTemporaryDirectory();
                            await download(Dio(), "http://$IP:5000/return_PDF",
                                tempDir.path + "/aaa.pdf");
                          },
                          child: Text("PDF",
                              style: TextStyle(color: Colors.white))),
                    ],
                  ),
                  ElevatedButton(
                      style: NotCopy
                          ? ButtonStyle(
                          backgroundColor:
                          MaterialStatePropertyAll(Colors.grey),
                        minimumSize: MaterialStatePropertyAll(Size.fromHeight(50)))
                          : ButtonStyle(
                          backgroundColor:
                          MaterialStatePropertyAll(Colors.blue),
                          minimumSize: MaterialStatePropertyAll(Size.fromHeight(50))),
                      onPressed: NotCopy?(){}:() {
                        Navigator.push(context, MaterialPageRoute(builder: (_){
                          return MyHomePage(IP,done,pdf_path);
                        }));
                      },
                      child: Text("Done",
                          style: TextStyle(color: Colors.white))),
                ]),
              ),
            ),
          ),
        ));
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
