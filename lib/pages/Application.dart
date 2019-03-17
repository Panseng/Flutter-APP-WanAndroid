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
	// 初始页面index
	int _page =0;
	PageController _pageController;
	
	// Nav Bottom格式、布局
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
	
	// 控制器
	@override
	void initState() {
		super.initState();
		// 初始化页面控制器，定位初始页面
		_pageController = PageController(initialPage: this._page);
	}
	
	
	// 销毁
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
		    // 配置页面
		    children: <Widget>[
		    	// 顺序与上面的Bottom挂钩
			    WeChatPage(),
			    MinePage()
		    ],
		    
		    // 随change传入页面index
		    onPageChanged: onPageChanged,
		    controller: _pageController,
	    ),
	    // 配置Bottom
	    bottomNavigationBar: BottomNavigationBar(
		    items: _bottomTabs,
		    currentIndex: _page,
		    fixedColor: GlobalConfig.colorPrimary,
		    type: BottomNavigationBarType.fixed,
		    onTap: onTap,
	    ),
    );
  }
  
  // 定位动画
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