import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
class imageView extends StatefulWidget {
  imageView({super.key, required this.imagePath,required this.ip});
  final imagePath;
  final ip;
  @override
  State<imageView> createState() => _imageViewState(imagePath,ip);
}

class _imageViewState extends State<imageView> {

  _imageViewState(this.imageFile,this.IP);
  final IP;
  var chr="";
  int n=0;
  final imageFile;
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
      var str="";
      for (int i = 0; i < int.parse(value); i++) {
        final res =
        await http.get(Uri.parse("http://$IP:5000/to_ocr?number=$i"));
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
                  Text(
                      chr,
                      style: TextStyle(
                          fontSize: 40,
                          color: Colors.white),
                      textAlign: TextAlign.right
                  ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: (){
                        Clipboard.setData(ClipboardData(text: chr));
                      },
                      child: Text("Copy",style: TextStyle(
                          color: Colors.white
                      )
                      )
                  ),
                  ElevatedButton(
                      onPressed: (){
                        _createPDF(chr);
                      },
                      child: Text("PDF",style: TextStyle(
                          color: Colors.white
                      )
                      )
                  ),
                ],
              )]),
        ),
      ),
    ));
  }
  Future<void> _createPDF(String sentance) async {
    //Create a new PDF document
    PdfDocument document = PdfDocument();

    //Add a new page and draw text
    PdfFont font =  PdfTrueTypeFont(await _readFontData(), 20);
    document.pages.add().graphics.drawString(
        sentance, font,
        brush: PdfSolidBrush(PdfColor(0, 0, 0)),
        bounds: Rect.fromLTWH(0, 0, 500, 50),
        format: PdfStringFormat(textDirection: PdfTextDirection.rightToLeft, alignment: PdfTextAlignment.right, paragraphIndent: 35));

    //Save the document
    List<int> bytes = await document.save();

    //Dispose the document
    document.dispose();

    //Get external storage directory
    final directory = await getApplicationSupportDirectory();

//Get directory path
    final path = directory.path;

//Create an empty file to write PDF data
    File file = File('$path/Output.pdf');

//Write PDF data
    await file.writeAsBytes(bytes, flush: true);

//Open the PDF document in mobile
    OpenFile.open('$path/Output.pdf');


  }

  Future<List<int>> _readFontData() async {
    final ByteData bytes = await rootBundle.load('assets/Regular.ttf');
    return bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes);
  }
}