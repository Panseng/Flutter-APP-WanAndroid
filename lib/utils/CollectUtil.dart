import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:flutter_app/common/User.dart';
import 'package:flutter_app/api/CommonService.dart';
import 'package:flutter_app/model/EmptyModel.dart';
import 'package:flutter_app/model/article_list/ArticleItemModel.dart';

/// 收藏
class CollectUtil {
	static updateCollectState(
			BuildContext context, ArticleItemModel model, Function callback) {
		if (!User().isLogin()) {
			callback(false, "收藏需要先登录");
		} else {
			if (model.collect) {
			
			}
		}
	}
}