import 'package:flutter/material.dart';
import 'package:flutter_app/common/GlobalConfig.dart';
import 'package:flutter_app/common/IconFont.dart';
import 'package:flutter_app/pages/wechat/WeChatPage.dart';
import 'package:flutter_app/pages/mine/MinePage.dart';

class ApplicationPage extends StatefulWidget{
	@override
	State<StatefulWidget> createState(){
		return _ApplicationPageState();
	}
}

class _ApplicationPageState
		extends State<ApplicationPage> with SingleTickerProviderStateMixin {
	int _page =0;
	PageController _pageController;
	
	final List<BottomNavigationBarItem> _bottomTabs = <BottomNavigationBarItem>[
		BottomNavigationBarItem(
			icon: Icon(IconFont.wechat),
			title: Text(GlobalConfig.weChatTab),
			backgroundColor: GlobalConfig.colorPrimary
		),
		BottomNavigationBarItem(
			icon: Icon(IconFont.me),
			title: Text(GlobalConfig.mineTab),
			backgroundColor: GlobalConfig.colorPrimary
		)
	];
	
	@override
	void initState() {
		super.initState();
		_pageController = PageController(initialPage: this._page);
	}
	
	@override
	void dispose() {
		_pageController.dispose();
		super.dispose();
	}
	
	@override
	Widget build(BuildContext context) {
    return Scaffold(
	    body: PageView(
		   physics: NeverScrollableScrollPhysics(),
		    children: <Widget>[
		    	WeChatPage(),
			    MinePage()
		    ],
		    onPageChanged: onPageChanged,
		    controller: _pageController,
	    ),
	    bottomNavigationBar: BottomNavigationBar(
		    items: _bottomTabs,
		    currentIndex: _page,
		    fixedColor: GlobalConfig.colorPrimary,
		    type: BottomNavigationBarType.fixed,
		    onTap: onTap,
	    ),
    );
  }
  
  void onTap(int index) {
		_pageController.animateToPage(
				index,
				duration: const  Duration(milliseconds: 300),
				curve: Curves.ease
		);
  }
  
  void onPageChanged(int page) {
		setState(() {
		  this._page = page;
		});
  }
}