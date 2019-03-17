import 'package:flutter/material.dart';
import 'package:flutter_app/common/IconFont.dart';

class BackBtn extends StatelessWidget {
	const BackBtn({Key key, this.color}) : super(key: key);
	final Color color;
	
	@override
	Widget build(BuildContext context) {
		assert(debugCheckHasDirectionality(context));
		return IconButton(
			icon: Icon(IconFont.back),
			color: color,
			tooltip: MaterialLocalizations.of(context).backButtonTooltip,
			onPressed: () {
				Navigator.maybePop(context);
			},
		);
	}
}