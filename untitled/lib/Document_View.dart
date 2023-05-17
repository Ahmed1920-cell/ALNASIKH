import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
class document_view extends StatelessWidget {
  final MetaData;
  const document_view({Key? key,this.MetaData}) : super(key: key);
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
                            child: Text("Document Review",style: TextStyle(fontSize: 24, color: Colors.white,fontWeight: FontWeight.bold))),
                      ),
                    ),
                    Container(
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
                                        File(MetaData["ImagePath"]),
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
                                      child: Text(MetaData["filename"],style: TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child:SelectableText(MetaData["Sentence"],
                                        style: TextStyle(fontSize: 17, color: Color.fromRGBO(211, 207, 207, 1),fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,textDirection: TextDirection.rtl,),
                                    ),
                                     Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        /*Tooltip(
                                        margin: EdgeInsets.fromLTRB(90, 5, 0, 0),
                                        textAlign: TextAlign.center,
                                        key: tooltipkey,
                                        message: 'Text Copied',
                                        triggerMode: TooltipTriggerMode.manual,
                                        showDuration: const Duration(seconds: 1),
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStatePropertyAll(Colors.black)),
                                          onPressed: () async{
                                            tooltipkey.currentState?.ensureTooltipVisible();
                                            Future.delayed(Duration(seconds: 2)).then((value) =>
                                                tooltipkey.currentState?.deactivate());
                                            await Clipboard.setData(ClipboardData(text: MetaData["Sentence"]));

                                          },
                                          child: Icon(Icons.copy,size: 25,color: Colors.white,),
                                        ),
                                      ),*/
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStatePropertyAll(Colors.black)),
                                          onPressed: () async{
                                            await Clipboard.setData(ClipboardData(text: MetaData["Sentence"]));
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
                                            OpenFile.open(MetaData["PdfPath"]);
                                          },
                                          child: Image.asset("assets/landing-pdf-converter.png",width: 30,height: 30,),),
                                        ElevatedButton(
                                          style: ButtonStyle(
                                              backgroundColor:
                                              MaterialStatePropertyAll(Colors.black)),
                                          onPressed: () async {
                                            await Share
                                                .shareFiles([
                                              MetaData["PdfPath"]
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
                  ],
                ),
              ),
            ),
          ),

      ),
    );
  }
}
