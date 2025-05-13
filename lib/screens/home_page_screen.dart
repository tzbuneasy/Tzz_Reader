import 'package:Tzz_Reader/screens/bookshelf_page_screen.dart';
import 'package:flutter/material.dart';
import 'package:Tzz_Reader/screens/book_text_screen.dart';
import 'package:Tzz_Reader/screens/favorites_page_screen.dart';
import 'package:Tzz_Reader/screens/generator_page_screen.dart';
import 'package:Tzz_Reader/screens/book_page_screen.dart';
import 'package:Tzz_Reader/screens/search_page_screen.dart';
import 'package:Tzz_Reader/main.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  //主要页面，有三个页面，分别是主页，收藏夹，搜索
  static  List<Widget> _pages = <Widget>[
    GeneratoPage(),
    BookshelfPage(),
    SearchPage(),
  ];

  //相关标题
  static const List<String> _titles = <String>[
    'Generator',
    'Favorites',
    'Search',
  ];

  //导航栏状态选择
  void _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    var appState = Provider.of<MyAppState>(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints){
        const double wideLayoutThreshold = 600; //宽度限制

        //统一下方的AppBar
        final PreferredSizeWidget appBar = AppBar(
          title: Text(_titles[_selectedIndex]),//标题
        );

        final bool isCurrentlyDark = appState.themeMode == ThemeMode.dark;

        //新版本的AppBar
        final PreferredSizeWidget unifiedAppBar = AppBar(
          title: Text(_titles[_selectedIndex]),//标题
          actions: [
            //切换按钮
            IconButton(
              icon: Icon(
                isCurrentlyDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
              tooltip: isCurrentlyDark ? "切换到亮色模式" : "切换到暗色模式",
              onPressed: () {
                appState.toggleTheme();
              },
            ),
          ],
        );

        //根据屏幕宽度更换布局
        if(constraints.maxWidth < wideLayoutThreshold) {

          //手机端布局
          return Scaffold(
            appBar: unifiedAppBar,

            //在下册的布局
            body: IndexedStack(
              index: _selectedIndex,
              children: _pages,
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '主页',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu_book),
                  label: '书架',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '搜索',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: _onDestinationSelected,
              type: BottomNavigationBarType.fixed,

            ),
          );

        } else {

          //宽屏布局
          return Scaffold(
            appBar: appBar,

            //在左侧的布局
            body: Row(
              children: <Widget>[
                NavigationRail(

                  //其成员其实差不多
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: _onDestinationSelected,
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: Text('主页'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.menu_book_outlined),
                      selectedIcon: Icon(Icons.menu_book),
                      label: Text('书架'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.search_outlined),
                      selectedIcon: Icon(Icons.search),
                      label: Text('搜索'),
                    ),
                  ],
                ),

                const VerticalDivider(thickness: 1,width: 1,),

                //填充剩余页面
                Expanded(
                  child: IndexedStack(
                    index: _selectedIndex,
                    children: _pages,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
    

    
  }
}
