import 'package:flutter/material.dart';

import 'package:flutter_app/common/GlobalConfig.dart';

class MinePage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _MinePageState();
	}
}

class _MinePageState extends State<MinePage> {
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(
				title: Text("Mine Page"),
			),
			body: new Row(
				mainAxisAlignment: MainAxisAlignment.center,
				children: <Widget>[
					Column(
						mainAxisAlignment: MainAxisAlignment.center,
						children: <Widget>[
							Text(
									"抱歉！暂未开发",
									style: TextStyle(
										color: GlobalConfig.color_tags,
										fontSize: 30,
									),
							),
							Text("Author: 潘生"),
							Text("Email: panseng.dr@qq.com"),
							Text("Tel: 13725593935")
						],
					)
				],
			),
		
		);
	}
}