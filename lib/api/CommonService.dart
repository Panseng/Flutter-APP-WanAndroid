import 'dart:async';
import 'package:dio/dio.dart';

import 'package:flutter_app/common/User.dart';
import 'package:flutter_app/model/wechat/WeChatModel.dart';

import 'Api.dart';

class CommonService {
	void getWeChatNames(Function callback) async {
		Dio().get(Api.MP_WECHAT_NAME, options: _getOptions()).then((response) {
			callback(WeChatModel.fromJson(response.data));
		});
	}
	
	Options _getOptions() {
		return Options(headers: User().getHeader());
	}
	
	Future<Response> login(String username, String password) async {
		FormData formData = new FormData.from({
			"username": "$username",
			"password": "$password",
		});
		return await Dio().post(Api.LOGIN, data: formData);
	}
	
	Future<Response> register(String username, String password) async {
		FormData formData = new FormData.from({
			"username": "$username",
			"password": "$password",
			"repassword": "$password",
		});
		return await Dio().post(Api.REGISTER, data: formData);
	}
}