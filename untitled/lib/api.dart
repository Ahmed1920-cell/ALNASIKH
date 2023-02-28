import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

 ocr() async {
  var path =
      r"E:\GP\Work\Detection_OCR_SERVER_files-20230226T193152Z-001\Detection_OCR_SERVER_files\test_image_num_1.jpg";
  var x = File(path).existsSync();
  var imageFile = File(path);
  var stream =
      new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
  // get file length
  var length = await imageFile.length();

  // string to uri
  var uri = Uri.parse("http://127.0.0.1:5000/to_detection");

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
          await http.get(Uri.parse("http://127.0.0.1:5000/to_ocr?number=$i"));
      if (res.statusCode == 200) {
        str=str+res.body;
        }
      }
    print(str);
  });
}


