//作为书架页面的主体内容，其中每本书的具体情况以BookCard形式生成


import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:Tzz_Reader/models/book_info.dart';
import 'package:yaml/yaml.dart';
import 'package:Tzz_Reader/screens/book_card_screen.dart';
class BookshelfPage extends StatefulWidget {
  const BookshelfPage({super.key});

  @override
  State<BookshelfPage> createState() => _BookshelfPageState();
}

class _BookshelfPageState extends State<BookshelfPage> {
  Future<List<BookInfo>>? _booksFuture; //后续构建所需要的信息

  @override
  void initState() {
    super.initState();
    _booksFuture = _loadBookshelfData(); //加载初始化信息
  }

  // 异步加载函数
  Future<List<BookInfo>> _loadBookshelfData() async {

    try{
      final String yamlString = await rootBundle.loadString('data/bookshelf.yaml'); //加载字符串
      final dynamic yamlData = loadYaml(yamlString); //解析字符串

      //转化为相关对象列表
      if(yamlData != null && yamlData['books'] is YamlList){
        final List<BookInfo> books = (yamlData['books'] as YamlList)
          .map((item) {
            // 确保 item 是 YamlMap 类型
            if (item is YamlMap) {
              return BookInfo.fromYaml(item);
            } 
            return null;
          })
          .whereType<BookInfo>()
          .toList();
        return books;
      } 
      return []; //保底操作
    } catch (e) {
      print('Error loading bookshelf data: $e'); //打印错误欣喜

      throw Exception(); //抛出异常
    }
  }

  @override
  // 重写build
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookInfo>>(
      future: _booksFuture, //监视对象
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('加载书架失败: ${snapshot.error}'),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('书架是空的，快去添加一些书籍吧！'));
        }

        // 数据加载成功
        final books = snapshot.data!;

        // 使用 GridView 来展示书籍卡片
        // 你可以根据屏幕宽度动态调整 crossAxisCount
        final screenWidth = MediaQuery.of(context).size.width;
        final crossAxisCount = (screenWidth / 160).floor().clamp(2, 5); // 每项大致宽度160，最少2列，最多5列

        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, // 列数
            crossAxisSpacing: 16.0,       // 卡片间的水平间距
            mainAxisSpacing: 16.0,        // 卡片间的垂直间距
            childAspectRatio: 2 / 3,      // 卡片的宽高比 (例如，宽度是2份，高度是3份，模仿书的形状)
          ),
          itemCount: books.length,
          itemBuilder: (context, index) {
            return BookCard(book: books[index]); //以BookCard方法展示书籍
          },
        );
      },
    );
  }
  

}