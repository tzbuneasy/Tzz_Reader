import 'package:Tzz_Reader/screens/home_page_screen.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    //一些预设的方案：
    const Color seedColor = Color.fromARGB(255, 34, 229, 255);

    final ThemeData lightTheme = ThemeData(
      fontFamily: 'Wenjing', //全局字体
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.light, //指明这是亮色主题
      ),
      //定制亮色主题下的特定组件样式
      appBarTheme: AppBarTheme(
        //确保 AppBar 颜色统一，并处理滚动时的颜色变化
        backgroundColor: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light).surface, //例如，使用 primary 作为 AppBar 背景
        foregroundColor: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light).onSurface, //AppBar 上文字和图标的颜色,使用对比色
        surfaceTintColor: Colors.transparent, //
        elevation: 2.0, //可以设置一个固定的阴影
        scrolledUnderElevation: 2.0, //滚动时阴影保持一致
      ),
      scaffoldBackgroundColor: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.light).surface, //Scaffold 背景色
     
    );

    //暗色主题
    final ThemeData darkTheme = ThemeData(
      fontFamily: 'Wenjing', //全局字体
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor, 
        brightness: Brightness.dark,//使用相同的种子颜色，但指定亮度为暗色
      ),
      //定制暗色主题下的特定组件样式
      appBarTheme: AppBarTheme(
        backgroundColor: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark).surface, //暗色 AppBar 背景可以选用 surface
        foregroundColor: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark).onSurface,
        surfaceTintColor: Colors.transparent, //同样防止滚动时颜色变化
        elevation: 2.0,
        scrolledUnderElevation: 2.0,
      ),
      scaffoldBackgroundColor: ColorScheme.fromSeed(seedColor: seedColor, brightness: Brightness.dark).surface,
      // ...
    );


    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child:Consumer<MyAppState>(
        builder:(context, appState, child) {
          return MaterialApp(
            title: 'Namer App',
            theme: lightTheme, //自定义的明亮主题
            darkTheme: darkTheme, //自定义的暗色主题
            themeMode: Provider.of<MyAppState>(context).themeMode, //使用全局状态管理的主题模式
            home: MyHomePage(),
            debugShowCheckedModeBanner: false,//去除debug标签
          );
        },
      ),
  
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void changeText() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void changeFavorites() {
    if(favorites.contains(current)){
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();

  }

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = (_themeMode == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light; //一键切换主题
    notifyListeners();
  } 
}

