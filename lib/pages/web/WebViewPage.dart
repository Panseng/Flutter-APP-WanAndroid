import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_app/common/IconFont.dart';
import 'package:flutter_app/model/article_list/ArticleItemModel.dart';
import 'package:flutter_app/utils/StringUtil.dart';
import 'package:flutter_app/widget/BackBtn.dart';

class WebViewPage extends StatefulWidget {
	final String url;
	final String title;
	final ArticleItemModel articleBean;
	
	WebViewPage({this.url, this.title, this.articleBean});
	
	@override
	State<StatefulWidget> createState() => new _WebViewState();
	
	String getUrl() {
		return (!StringUtil.isNullOrEmpty(url))
				? url
				: ((null != articleBean) ? articleBean.link : "");
	}
	
	String getTitle() {
		return (!StringUtil.isNullOrEmpty(title))
				? title
				: ((null != articleBean) ? articleBean.title : "");
	}
}

class _WebViewState extends State<WebViewPage> {
	String toastMsg;
	
	@override
	Widget build(BuildContext context) {
		return WebviewScaffold(
			url: widget.getUrl(),
			appBar: AppBar(
				title: Text(
					null != toastMsg ? toastMsg : widget.getTitle(),
					textAlign: null != toastMsg ? TextAlign.center : TextAlign.start,
					style:  null != toastMsg
							? TextStyle(fontSize: 15.0, color: Colors.yellow,) : null,
				),
				leading:  BackBtn(),
				actions: <Widget>[
					// _buildStared(context), // 收藏
					_buildOpenWithBrowser(),
				],
			),
		);
	}
	
	/* 收藏动作
	Widget _buildStared(BuildContext context) {
		if(null == widget.articleBean || null == widget.articleBean.collect) {
			return Text("");
		} else {
			return IconButton(
				icon: Icon(
					(widget.articleBean.collect) ? IconFont.like_fill : IconFont.like_stroke,
					color: Colors.white,
				),
				onPressed: () {
					CollectUtil.updateCollectState(context, widget.articleBean,
									(bool isOK, String errorMsg) {
								if (isOK) {
									setState(() {
										widget.articleBean.collect = !widget.articleBean.collect;
									});
								} else {
									setState(() {
										toastMsg = errorMsg;
									});
									Timer(Duration(seconds: 2), () {
										setState(() {
											toastMsg = null;
										});
									});
								}
							});
				},
			);
		}
	}
	*/
	
	// 打开浏览器
	Widget _buildOpenWithBrowser() {
		return IconButton(
			icon: Icon(IconFont.browser),
			onPressed: () {
				launch(widget.getUrl());
			},
		);
	}
}