
import 'package:bill/view/test/AnimateNumberTest.dart';
import 'package:bill/view/test/AnimatedSwitcherCounterRoute.dart';
import 'package:bill/view/test/ThemeColors.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        //移除抽屉菜单顶部默认留白
        removeTop: true,
        child: Stack(
          children: <Widget>[
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: const Text('个人中心'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.color_lens),
                        title: Text('主题'),
                        onTap: () => Navigator.pushNamed(context, "themes"),
                      ),
                      ListTile(
                        leading: const Icon(Icons.color_lens),
                        title: Text('ThemeColors'),
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ThemeColors())),
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: Text('test'),
                        onTap: () => Navigator.pushNamed(context, "/test"),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ]
        )
      ),
    );
  }

   Widget _buildHeader(context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Theme.of(context).primaryColorDark, Theme.of(context).primaryColor, Theme.of(context).textSelectionColor],
          ),
        ),
        padding: EdgeInsets.only(top: 40, bottom: 20),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipOval(
                // 如果已登录，则显示用户头像；若未登录，则显示默认头像
                child: Image.asset(
                        "assets/imgs/default_avatar.png",
                        width: 80,
                      ),
              ),
            ),
            Text(
              'CG lkw',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
                    
          ],
        ),
      ),
    );
  }
}