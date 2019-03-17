import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/article_list/ArticleItemModel.dart';
import 'package:flutter_app/pages/web/WebViewPage.dart';

class Router {
	openWeb(BuildContext context, String url, String title) {
		Navigator.of(context)
				.push(MaterialPageRoute(builder: (BuildContext context) {
					return WebViewPage(url: url, title: title);
		}));
	}
	
	openArticle(BuildContext context, ArticleItemModel item) {
		Navigator.of(context)
				.push(MaterialPageRoute(builder: (BuildContext context) {
					return WebViewPage(articleBean: item);
		}));
	}
	
	back(BuildContext context) {
		Navigator.of(context).pop();
	}
	
	Widget _transitionsBuilder(BuildContext context, Animation<double> animation,
			Animation<double> secondaryAnimation, Widget child) {
		return FadeTransition(
			opacity: animation,
			child: FadeTransition(
				opacity: Tween<double>(begin: 0.5, end: 1.0).animate(animation),
				child: child,
			),
		);
	}
}
