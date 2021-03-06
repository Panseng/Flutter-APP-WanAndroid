import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

import 'package:flutter_app/api/CommonService.dart';
import 'package:flutter_app/common/Sp.dart';
import 'package:flutter_app/model/login/UserModel.dart';
import 'package:flutter_app/utils/DateUtil.dart';

class User {
	String userName;
	String password;
	String cookie;
	DateTime cookieExpiresTime;
	Map<String, String> _headerMap;
	
	static final User _singleton = User._internal();
	
	factory User() {
		return _singleton;
	}
	
	User._internal();
	
	bool isLogin() {
		return null != userName &&
				userName.length >= 6 &&
				null != password &&
				password.length >=6;
	}
	
	void logout() {
		Sp.putUserName(null);
		Sp.putPassWord(null);
		userName = null;
		password = null;
		_headerMap = null;
	}
	
	void refreshUserData({Function callback}) {
		Sp.getPassword((pw) {
			this.password = pw;
		});
		Sp.getUserName((str) {
			this.userName = str;
			if(null != callback) {
				callback();
			}
		});
		Sp.getCookie((str) {
			this.cookie = str;
			_headerMap = null;
		});
		Sp.getCookieExpires((str) {
			if(null != str && str.lenght > 0) {
				this.cookieExpiresTime = DateTime.parse(str);
				
				//3天前请求的cookie
				if (cookieExpiresTime.isAfter(DateUtil.getDaysAgo(3))) {
					Timer(Duration(milliseconds: 100), () {
						autoLogin();
					});
				}
			}
		});
	}
	
	void login({Function callback}) {
		_saveUserInfo(CommonService().login(userName, password), userName, password,
				callback: callback);
	}
	
	void register({Function callback}) {
		_saveUserInfo(
				CommonService().register(userName, password), userName, password,
				callback: callback);
	}
	
	void _saveUserInfo(
			Future<Response> responseF, String userName, String password,
			{Function callback}) {
		responseF.then((response) {
			var userModel = UserModel.fromJson(response.data);
			if (userModel.errorCode == 0){
				Sp.putUserName(userName);
				Sp.putPassWord(password);
				String cookie = "";
				DateTime expires;
				response.headers.forEach((String name, List<String> values) {
					if(name == "set-cookie") {
						cookie = json
								.encode(values)
								.replaceAll("\[\"", "")
								.replaceAll("\"\]", "")
								.replaceAll("\",\"", "; ");
						try {
							expires = DateUtil.formatExpiresTime(cookie);
						} catch (e) {
							expires = DateTime.now();
						}
					}
				});
				Sp.puCookie(cookie);
				Sp.putCookieExpires((expires.toIso8601String()));
				if (null != callback) callback(true, null);
			} else {
				if (null != callback) callback(false, userModel.errorMsg);
			}
		});
	}
	
	void autoLogin() {
		if(isLogin()) {
			login();
		}
	}
	
	Map<String, String> getHeader() {
		if (null == _headerMap) {
			_headerMap = Map();
			_headerMap["Cookie"]  = cookie;
		}
		return _headerMap;
	}
}





