// redux ；练习

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../Entry.dart';

// action
class ChangeHomeBoxColorsAction {
  final HomeBoxColorEnum homeBoxColorEnum;

  ChangeHomeBoxColorsAction(this.homeBoxColorEnum);
}

class ChangeHomeListStateAction {}

class ChangeUserNameAction {
  final UserInfo userInfo;
  ChangeUserNameAction(this.userInfo);
}

// sync action
syncAction(String userName) {
  return (Store<String> store) async {
    print("ASDASD");
    final reversUserName = await Future.delayed(
        Duration(seconds: 1), () => userName + DateTime.now().toString());
    store.dispatch(ChangeUserNameAction(UserInfo(reversUserName)));
  };
}

// actionCreator
// reducer
AppState homeUIReducer(AppState state, action) {
  if (action is ChangeHomeBoxColorsAction) {
    // 数据不可变？
    return AppState(HomeUI(action.homeBoxColorEnum, state.homeUI.listStateEnum),
        state.userInfo);
  }
  return state;
}

AppState userInfoReducer(AppState state, action) {
  if (action is ChangeUserNameAction) {
    String userName = action.userInfo.userName;
    return AppState(state.homeUI, UserInfo(userName));
  }
  // 数据不可变？
  return state;
}

// 合并多个reducer
var appCombineReducers =
    combineReducers<AppState>([homeUIReducer, userInfoReducer]);
// model
// 盒子颜色
enum HomeBoxColorEnum { RED_BOX, BLACK_BOX, BLUE_BOX }
// 列表状态
enum ListStateEnum {
  FOLD,
  UNFOLD,
}

// home ui相关
class HomeUI {
  final HomeBoxColorEnum homeBoxColorEnum;
  final ListStateEnum listStateEnum;

  HomeUI(this.homeBoxColorEnum, this.listStateEnum);
}

// 用户信息
class UserInfo {
  final String userName;

  UserInfo(this.userName);
}

class AppState {
  final HomeUI homeUI;
  final UserInfo userInfo;

  AppState(this.homeUI, this.userInfo);
}

// store
final store = Store<AppState>(
  appCombineReducers,
  initialState: AppState(
    HomeUI(HomeBoxColorEnum.RED_BOX, ListStateEnum.FOLD),
    UserInfo("zhoutengshen"),
  ),
  middleware: [thunkMiddleware],
);

void main() {
  runApp(
    MyEntry(
      widget: StoreProvider(
        store: store,
        child: Home(),
      ),
    ),
  );
}

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomeState();
  }
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        FunctionButton(),
        Center(
          child: Column(
            children: <Widget>[
              UiBoxColorsTest(),
              UserInfoTest(),
            ],
          ),
        ),
      ],
    );
  }
}

class UiBoxColorsTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, HomeBoxColorEnum>(
      converter: (store) {
        return store.state.homeUI.homeBoxColorEnum;
      },
      builder: (ctx, HomeBoxColorEnum colorEnum) {
        return Container(
          height: 100,
          width: 100,
          color: colorEnum == HomeBoxColorEnum.BLUE_BOX
              ? Colors.blue
              : colorEnum == HomeBoxColorEnum.RED_BOX
                  ? Colors.red
                  : Colors.black87,
        );
      },
    );
  }
}

class UserInfoTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, String>(
      converter: (store) => store.state.userInfo.userName,
      builder: (ctx, String name) {
        return Text(name);
      },
    );
  }
}

class FunctionButton extends StatelessWidget {
  _onTapBtn1() {
    StoreProvider.of<AppState>(tempCtx).dispatch(
      ChangeHomeBoxColorsAction(HomeBoxColorEnum.RED_BOX),
    );
    StoreProvider.of<AppState>(tempCtx)
        .dispatch(ChangeUserNameAction(UserInfo("RED_BOX")));
  }

  _onTapBtn2() {
    StoreProvider.of<AppState>(tempCtx).dispatch(
      ChangeHomeBoxColorsAction(HomeBoxColorEnum.BLUE_BOX),
    );
    StoreProvider.of<AppState>(tempCtx)
        .dispatch(ChangeUserNameAction(UserInfo("BLUE_BOX")));
  }

  _onTapBtn3() {
    StoreProvider.of<AppState>(tempCtx).dispatch(
      ChangeHomeBoxColorsAction(HomeBoxColorEnum.BLACK_BOX),
    );
    StoreProvider.of<AppState>(tempCtx)
        .dispatch(ChangeUserNameAction(UserInfo("BLACK_BOX")));
  }

  _onTapBtn11() {
    StoreProvider.of<AppState>(tempCtx).dispatch(
        syncAction("异步Action")
    );
  }

  var tempCtx;

  @override
  Widget build(BuildContext context) {
    tempCtx = context;
    // TODO: implement build
    return Stack(
      children: <Widget>[
        Positioned(
          right: 150,
          bottom: 200,
          child: RaisedButton(
            child: Text("CHANGE RED_BOX"),
            onPressed: _onTapBtn1,
          ),
        ),
        Positioned(
          right: 150,
          bottom: 100,
          child: RaisedButton(
            child: Text("CHANGE BLACK_BOX"),
            onPressed: _onTapBtn2,
          ),
        ),
        Positioned(
          right: 100,
          bottom: 50,
          child: RaisedButton(
            child: Text("CHANGE BLACK_BOX"),
            onPressed: _onTapBtn3,
          ),
        ),
        Positioned(
          right: 100,
          top: 150,
          child: RaisedButton(
            child: Text("SYNC ACTION"),
            onPressed: _onTapBtn11,
          ),
        )
      ],
    );
  }
}
