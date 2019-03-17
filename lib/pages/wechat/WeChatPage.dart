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

class _WeChatPageState extends State<WeChatPage>
				with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
	List<WeChatItemModel> _list = List();
	Map<int, Pair<ArticleListPage, GlobalKey<ArticleListPageState>>>
			_itemListPageMap = Map();
	TabController _tabController;
	var _controller = TextEditingController();
	int _currentItemIndex = 0;
	var _maxCachePageNums = 5;
	var _cachedPageNum = 0;
	String _searchKey = "";
	
	@override
	bool get wantKeepAlive => true;
	
	@override
	void initState() {
		super.initState();
		_loadWeChatNames();
	}
	
	@override
	Widget build(BuildContext context) {
		return Scaffold(
			resizeToAvoidBottomPadding: false,
			appBar: _buildNormalAppbar(),
			body: _list.length <=0
					? null
					: TabBarView(
							children: _buildPages(context),
							controller: _tabController,
						),
		);
	}
	
	AppBar _buildNormalAppbar() {
		return AppBar(
			title: Text(GlobalConfig.weChatTab),
			centerTitle: true,
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
					_updataState(model.data);
				});
			}
		});
	}
	
	void _updataState(List<WeChatItemModel> list) {
		_list = list;
		_tabController =TabController(length: _list.length, vsync: this);
		_tabController.addListener(() {
			_currentItemIndex = _tabController.index;
		});
	}
	
	@override
	void dispose() {
		_tabController?.dispose();
		_controller?.dispose();
		super.dispose();
	}
}