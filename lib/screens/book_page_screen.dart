// lib/book_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle; 
import 'package:Tzz_Reader/screens/book_text_screen.dart'; 

class BookPage extends StatelessWidget {
  final String bookAssetPath; //一般输入为 "assets/books/我的小说.txt"
  final String bookTitle;     //书名

  const BookPage({
    Key? key,
    required this.bookAssetPath,
    required this.bookTitle,
  }) : super(key: key);

  //异步方法，用于从 assets 加载文本文件内容
  Future<String> _loadBookContent() async {
    try {
      //rootBundle.loadString 会返回一个 Future<String>
      //Txt文件是有编码之分的，比如GBK、UTF-8
      //但通常 UTF-8 是默认且推荐的
      return await rootBundle.loadString(bookAssetPath);
    } catch (e) {
      //如果文件加载失败，可以抛出异常或返回错误信息
      print('Error loading book content: $e');
      return '无法加载书籍内容: $e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _loadBookContent(), // 设置 FutureBuilder 的 future 为加载书籍内容的方法
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        //根据 Future 的状态构建不同的 UI
        if (snapshot.connectionState == ConnectionState.waiting) {
          //状态1: 正在加载中，展示加载动画
          return Scaffold(
            appBar: AppBar(
              title: Text('正在加载: $bookTitle...'),
            ),
            body: const Center(
              child: CircularProgressIndicator(), // 显示加载指示器
            ),
          );
        } else if (snapshot.hasError) {
          // 状态2: 加载过程中发生错误
          return Scaffold(
            appBar: AppBar(
              title: Text('加载错误'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('加载书籍 "$bookTitle" 失败: ${snapshot.error}'),
              ),
            ),
          );
        } else if (snapshot.hasData) {
          // 状态3: 数据成功加载完成
          // snapshot.data 包含了加载到的字符串内容
          // 使用 BookTextViewer 显示书籍内容，这里面才是文段显示的页面
          return BookTextViewer(
            textContent: snapshot.data!, 
            textTitle: bookTitle,
          );
        } else {
          // 状态4: 其他情况 (例如 future 为 null，理论上不应发生在此处，所以此处仅作安全处理使用)
          return Scaffold(
            appBar: AppBar(
              title: Text('未知状态'),
            ),
            body: const Center(
              child: Text('正在初始化书籍...'),
            ),
          );
        }
      },
    );
  }
}