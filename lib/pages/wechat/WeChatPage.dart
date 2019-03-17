import 'package:flutter/material.dart';

import 'package:flutter_app/api/Api.dart';
import 'package:flutter_app/api/CommonService.dart';
import 'package:flutter_app/common/GlobalConfig.dart';
import 'package:flutter_app/common/Pair.dart';
import 'package:flutter_app/model/wechat/WeChatItemModel.dart';
import 'package:flutter_app/model/wechat/WeChatModel.dart';
import 'package:flutter_app/pages/article_list/ArticleListPage.dart';


class WeChatPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() {
		return _WeChatPageState();
	}
}

// AutomaticKeepAliveClientMixin用于keepAlive
// SingleTickerProviderStateMixin 实现动画效果
class _WeChatPageState extends State<WeChatPage>
				with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
	List<WeChatItemModel> _list = List();
	// 使用GlobalKey做为控件的key, 允许element在树周围移动(改变父节点), 而不会丢失状态
	Map<int, Pair<ArticleListPage, GlobalKey<ArticleListPageState>>>
			_itemListPageMap = Map();
	// 与page controller区别 均需要在相应button和页面中配置controller
	TabController _tabController;
	// int _currentItemIndex = 0;
	var _maxCachePageNums = 5;
	var _cachedPageNum = 0;
	String _searchKey = "";
	
	@override
	bool get wantKeepAlive => true;
	
	@override
	void initState() {
		super.initState();
		// 初始化，获取公众号名称
		_loadWeChatNames();
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			// 类似于 Android 中的 android:windowSoftInputMode=”adjustResize”
			// 控制界面内容 body 是否重新布局来避免底部被覆盖了
			// 比如当键盘显示的时候，重新布局避免被键盘盖住内容。默认值为 true。
			resizeToAvoidBottomPadding: false,
			// app bar
			appBar: _buildNormalAppbar(),
			body: _list.length <=0
					? null
					: TabBarView(
							children: _buildPages(context),
							controller: _tabController,
						),
		);
	}
	
	// appBar范畴
	AppBar _buildNormalAppbar() {
		return AppBar(
			// title
			title: Text(GlobalConfig.weChatTab),
			centerTitle: true,
			// bottom
			bottom: _buildSubTitle(),
		);
	}
	
	TabBar _buildSubTitle() {
		return _list.length <= 0
				? null
				: TabBar(
						controller: _tabController,
						labelColor: Colors.white,
						isScrollable: true,
						unselectedLabelColor: GlobalConfig.color_white_a80,
						indicatorSize: TabBarIndicatorSize.label,
						indicatorPadding: EdgeInsets.only(bottom: 2.0),
						indicatorWeight: 1.0,
						indicatorColor: Colors.white,
						tabs: _buildTabs(),
					);
	}
	
	List<Widget> _buildTabs() {
		// 将数据对应到tabs
		return _list?.map((WeChatItemModel _bean) {
			return Tab(
				text: _bean?.name,
			);
		})?.toList();
	}
	
	List<Widget> _buildPages(BuildContext context) {
		return _list?.map((_bean) {
			if (!_itemListPageMap.containsKey(_bean.id)) {
				var key = GlobalKey<ArticleListPageState>();
				// 增加 page
				// Pair：起返回键值对作用
				_itemListPageMap[_bean.id] = Pair(
					ArticleListPage(
						key: key,
						keepAlive: _keepAlive(),
						emptyMsg: '未搜索到内容',
						request: (page) {
							return CommonService().getWeChatListData(
									"${Api.MP_WECHAT_LIST}${_bean.id}/$page/json?k=$_searchKey");
						}
					),
				key);
			}
			return _itemListPageMap[_bean.id].first;
		})?.toList();
	}
	
	bool _keepAlive() {
		if(_cachedPageNum < _maxCachePageNums) {
			_cachedPageNum++;
			return true;
		} else {
			return false;
		}
	}
	
	void _loadWeChatNames() async {
		CommonService().getWeChatNames((WeChatModel model) {
			if (model.data.length > 0) {
				setState(() {
					// 更新sub title信息
					_updataState(model.data);
				});
			}
		});
	}
	
	void _updataState(List<WeChatItemModel> list) {
		_list = list;
		// 初始化 controller
		_tabController =TabController(length: _list.length, vsync: this);
		/*
		_tabController.addListener(() {
			// 监听变化
			_currentItemIndex = _tabController.index;
		});
		*/
	}
	
	@override
	void dispose() {
		_tabController?.dispose();
		super.dispose();
	}
}