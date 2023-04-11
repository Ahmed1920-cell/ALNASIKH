import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'main.dart';

class ip extends StatefulWidget {
  ip(this.I, this.done);

  var I;
  final done;

  @override
  State<ip> createState() => _ipState();
}

class _ipState extends State<ip> {
  String dropdownValue = 'http://';
  String selectedValue='http://';
  List<String> items = [
    'http://',
    'https://',
  ];
  final _textController = TextEditingController();

  send_ip(BuildContext ctx, String IP) {
    Navigator.pushReplacement(ctx, MaterialPageRoute(builder: (_) {
      return MyHomePage(IP, widget.done, "");
    }));
  }

  @override
  Widget build(BuildContext context) {
    var spl=widget.I.toString();
    var hpp=spl.split("//");
      if(hpp[0]=="http:" ||hpp[0]=="https:" )
      selectedValue=hpp[0]+"//";
    var rem=widget.I.toString();
    widget.I=rem.replaceAll('http://', "").replaceAll("https://", "");
    var list=widget.I.toString();
    //_textController.text = widget.I.toString();
    _textController.text = list;
    print(_textController.text);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: Container(
          color: Colors.black,
          child: Container(
              width: double.infinity,
              alignment: Alignment.center,
              child: SingleChildScrollView(
                  child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(" IP Address",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontSize: 19),),
                    Container(padding: EdgeInsets.all(8),
                      margin:EdgeInsets.all(8) ,
                      decoration: BoxDecoration(
                        border:Border.all(color: Colors.blue,width: 5),
                        borderRadius: BorderRadius.circular(25),
                        //Colors.grey.withOpacity(0.3)
                      ),
                      child: Row(
                        children: [
                          DropdownButtonHideUnderline(
                            child: DropdownButton2(

                              style: TextStyle(),
                              dropdownStyleData: DropdownStyleData(
                                width: 95,
                                decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Colors.blue,
                              ),
                                offset: const Offset(-10, 0),
                              ),
                              hint: Text(
                                'Select Item',
                                style:
                                    TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              items: items
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                              fontSize: 18,
                                              color: Colors.white),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedValue = value as String;
                                });
                              },
                              buttonStyleData: ButtonStyleData(width: 100,padding: EdgeInsets.fromLTRB(5, 0, 0, 0),decoration: BoxDecoration()
                              ),
                              menuItemStyleData: MenuItemStyleData(selectedMenuItemBuilder: (BuildContext context,child) {
                                  return Container(
                                    child: child,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(34),
                                      color: Color.fromRGBO(
                                          75, 95, 119, 1.0),
                                    ),
                                  );
                              },),
                            ),
                          ),
                          SizedBox(
                            // <-- SEE HERE
                            width: 200,
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: _textController,
                              keyboardType: TextInputType.name,
                              decoration: InputDecoration(
                                  hintText: "Enter IP",
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold)
                                  //prefixStyle:TextStyle(color: Colors.white)

                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5,),
                    ElevatedButton(
                        onPressed: () => send_ip(context, selectedValue+_textController.text),
                        child: Text("Send"))
                  ],
                ),
              ))),
        ),
      ),
    );
  }
}
