import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
class imageView extends StatefulWidget {
  imageView({super.key, required this.imagePath});
  final imagePath;

  @override
  State<imageView> createState() => _imageViewState(imagePath);
}

class _imageViewState extends State<imageView> {
  _imageViewState(this.imageFile);
  var chr="";
  int n=0;
  final imageFile;
  ocr() async {
    var stream =
    new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    // get file length
    var length = await imageFile.length();

    // string to uri
    var uri = Uri.parse("http://192.168.1.7:5000/to_detection");

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
      var str="";
      for (int i = 0; i < int.parse(value); i++) {
        final res =
        await http.get(Uri.parse("http://192.168.1.7:5000/to_ocr?number=$i"));
        if (res.statusCode == 200) {
          str=str+res.body;
          setState(() {
            chr=str;
          });
        }
      }
      print(str);
    });
  }

  @override
  Widget build(BuildContext context) {
    if(n==0)
    ocr();
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
                child: Column(
              children: [
                Image.file(
                  imageFile,
                  width: 400,
                  height: 400,
                ),
                Text(chr,style: TextStyle(color: Colors.white),textAlign: TextAlign.right)
              ],
            )),
          ),
        ),
    );
  }
}
