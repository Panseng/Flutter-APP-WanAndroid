import 'package:flutter/material.dart';

class WeChatPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _WeChatPageState();
	}
}

class _WeChatPageState extends State<WeChatPage> {
	
	@override
	Widget build(BuildContext context) {
    return Scaffold(
	    appBar: AppBar(
		    title: Text("WeChat Page"),
	    ),
	    body: new Text("Hello World"),
	    
    );
  }
}