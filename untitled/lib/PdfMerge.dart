import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';

import 'sql.dart';
class merge_pdf extends StatefulWidget {
  const merge_pdf({super.key});

  @override
  State<merge_pdf> createState() => _merge_pdfState();
}

class _merge_pdfState extends State<merge_pdf> {
  List data = [];
  List temp = [];
  Sql DB = Sql();

  readData() async {
    List<Map> response = await DB.read("alnasikh");
    data.addAll(response);
    if (this.mounted) {
    }
    print(data.length);
  }
  @override
  void initState() {
    // TODO: implement initState
    readData();
    temp = data;
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            color: Colors.deepPurpleAccent,
            foregroundColor: Colors.black,
            systemOverlayStyle: SystemUiOverlayStyle( //<-- SEE HERE
              // Status bar color
              statusBarColor: Colors.black,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness: Brightness.dark,
            ),)
      ),
      home: Scaffold(
        backgroundColor: Colors.black,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: SafeArea(
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.all(10),
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Center(
                      child: Container(

                          padding: EdgeInsets.fromLTRB(30, 10, 30, 10),
                          decoration: BoxDecoration(
                            //color: Colors.blue,
                            //color: Color.fromRGBO(218, 148, 11, 1.0),
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Text("Pdf Merge",style: TextStyle(fontSize: 24, color: Colors.white,fontWeight: FontWeight.bold))),
                    ),
                  ),
                  ListView.builder(
                    reverse: false,
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    //physics: AlwaysScrollableScrollPhysics(),
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: temp.length,
                    itemBuilder: (context, i) => Container(
                      margin: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: (i != 0)
                                ? const EdgeInsets.fromLTRB(0, 0, 0, 10)
                                : const EdgeInsets.fromLTRB(0, 0, 0, 50),
                            child: Container(
                              margin: EdgeInsets.all(8),
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius: BorderRadius.circular(25.0), //<-- SEE HERE
                                ),
                                color: Colors.black,
                                clipBehavior: Clip.hardEdge,
                                shadowColor: Color.fromRGBO(218, 148, 11, 1.0),
                                //shadowColor: Colors.blueAccent,
                                elevation: 15,
                                child: Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                          child: InteractiveViewer(
                                            panEnabled: false, // Set it to false
                                            minScale: 1,
                                            maxScale: 4,
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(15),
                                                  topRight: Radius.circular(15)),
                                              child: Image.file(
                                                File(temp[i]["ImagePath"]),
                                                //height: 200,
                                                width: 400,
                                                //fit: BoxFit.cover,
                                              ),
                                            ),
                                          )
                                      ),
                                      Container(
                                        decoration: BoxDecoration(

                                          color: Colors.black,
                                          //Colors.grey.withOpacity(0.3)
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.all(8),
                                              alignment: Alignment.center,
                                              child: Text(temp[i]["filename"],style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child:SelectableText(temp[i]["Sentence"],
                                                style: TextStyle(fontSize: 17, color: Color.fromRGBO(211, 207, 207, 1),fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.right,textDirection: TextDirection.rtl,),
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStatePropertyAll(Colors.black)),
                                                  onPressed: () async{
                                                    await Clipboard.setData(ClipboardData(text: temp[i]["Sentence"]));
                                                    Fluttertoast.showToast(msg: "Text Copied",fontSize: 14,backgroundColor: Color.fromRGBO(
                                                        80, 80, 80, 1.0));

                                                  },
                                                  child: Icon(Icons.copy,size: 25,color: Colors.white,),
                                                ),
                                                SizedBox(width: 10),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStatePropertyAll(Colors.black)),
                                                  onPressed: () async {
                                                    //var tempDir = await getTemporaryDirectory();
                                                    OpenFile.open(temp[i]["PdfPath"]);
                                                  },
                                                  child: Image.asset("assets/landing-pdf-converter.png",width: 30,height: 30,),),
                                                ElevatedButton(
                                                  style: ButtonStyle(
                                                      backgroundColor:
                                                      MaterialStatePropertyAll(Colors.black)),
                                                  onPressed: () async {
                                                    await Share
                                                        .shareFiles([
                                                      temp[i]["PdfPath"]
                                                    ],
                                                        text: 'Great picture');
                                                  },
                                                  child: Icon(
                                                    Icons.share,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ],
                                            ) ,
                                          ],
                                        ),
                                      ),
                                    ]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}
