import 'package:flutter/material.dart';

import 'main.dart';

class ip extends StatelessWidget {
  ip(this.I,this.done);
  final I;
  final done;
  final _textController = TextEditingController();
  send_ip(BuildContext ctx, String IP) {
Navigator.push(ctx, MaterialPageRoute(builder: (_){
  return MyHomePage(IP,done,"");
}));
  }

  @override
  Widget build(BuildContext context) {
    _textController.text=I.toString();
    print(_textController.text);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('settings'),
        ),
        body: Container(
          color: Colors.black,
          child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    style: TextStyle(color: Colors.white),
                    controller: _textController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 3, color: Colors.blue),
                            borderRadius: BorderRadius.circular(50)),
                        labelText: "IP",
                        labelStyle: TextStyle(
                            color: Colors.blue,
                            fontSize: 19,
                            fontWeight: FontWeight.bold),
                        hintText: "Enter IP",
                        hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 19,
                            fontWeight: FontWeight.bold)
                        //prefixStyle:TextStyle(color: Colors.white)

                        ),
                  ),
                  ElevatedButton(
                      onPressed: () => send_ip(context, _textController.text),
                      child: Text("Send"))
                ],
              )),
        ),
      ),
    );
  }
}
