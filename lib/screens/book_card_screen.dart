//书架上每本书的卡片实例

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:Tzz_Reader/models/book_info.dart';
import 'package:Tzz_Reader/screens/book_page_screen.dart'; //你的阅读页面,或者说点击跳转的页面

//因为一些动画的需求，此处使用有状态类
class BookCard extends StatefulWidget {
  final BookInfo book;
  const BookCard({super.key, required this.book});

  @override
  State<BookCard> createState() => _BookCardState();
}

  
class _BookCardState extends State<BookCard> {

  bool _is_press = false; //是否按下 
  late final BookInfo book;

  //初始化代码
  @override
  void initState() {
    super.initState();
    book = widget.book; //避免此常用参数全用widget.book,影响可读性
  }

  @override
  Widget build(BuildContext context) {

    String readingInfoText;
    if (book.readingPercentage != null) {
      if (book.readingPercentage! >= 1.0) {
        readingInfoText = '已读完';
      } else if (book.readingPercentage! == 0.0) {
        readingInfoText = '未开始';
      } else {
        //intl包，其实我觉得百分比条更好看
        final percentageFormat = NumberFormat.percentPattern();
        readingInfoText = '已读 ${percentageFormat.format(book.readingPercentage)}';//这个“已读”其实可以扔了，百分比已经很清楚了
      }
    } else {
      readingInfoText = book.author ?? ''; //如果没有百分比，显示作者或留空
    }


    final double press_scale = _is_press ? 1.05 : 1.00; //按下时放大bili
    //GestureDetector目的是检测相关手势，此时InkWell作用不大
    return GestureDetector(

      onTapDown: (_) => setState(() {_is_press = true;}), //按下
      onTapUp: (_) => setState(() {_is_press = false;}), //抬起
      onTapCancel: () => setState(() {_is_press = false;}), //取消
      child: InkWell(

        onTap: () {
          if (book.contentAssetPath.isNotEmpty) {

            //若页面存在，则压栈页面
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BookPage( // 确保 BookPage 已正确导入
                  bookAssetPath: book.contentAssetPath,
                  bookTitle: book.title,
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('书籍内容路径无效')),
            );
          }
        },

      //一些额外调整
      hoverColor: Colors.transparent,//移除覆盖效果
      splashColor: Colors.transparent,//移除水波效
      highlightColor: Colors.transparent,//移除高亮效,其实更像是颜色遮罩？

      //内容填充
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, //让文本居中对齐封面
          children: <Widget>[

            //书籍封面图片 (方方正正，带阴影)要让图片区域占据主要空间，并能适应 GridView 的单元格分配
            Expanded( //

              //缩放动画
              child: AnimatedScale(

                //相关参数
                scale: press_scale, //缩放
                duration: const Duration(milliseconds: 200), //时长
                curve: Curves.easeOut, //动画曲线

                child: AspectRatio(
                  aspectRatio: 1.0, //正方形
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8.0), // 图片和下方文字的间距
                    decoration: BoxDecoration(
                      color: Colors.grey[200], // 图片加载前的背景色或无封面时的背景
                      borderRadius: BorderRadius.circular(8.0), // 轻微的圆角
                      boxShadow: [ //添加阴影,并非整体蒙版，而是图片阴影
                        BoxShadow(
                          color: Colors.black.withValues(alpha: _is_press? 0.40:0.30),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2), // 阴影偏移量
                        ),
                      ],
                    ),
                    child: ClipRRect( //裁剪图片以匹配圆角
                      borderRadius: BorderRadius.circular(8.0),
                      child: (book.coverAssetPath != null && book.coverAssetPath!.isNotEmpty)
                          ? Image.asset(
                              book.coverAssetPath!,
                              fit: BoxFit.cover, //图片填满容器
                              errorBuilder: (context, error, stackTrace) {
                                return Center(child: Icon(Icons.broken_image, color: Colors.grey[500], size: 40));
                              },
                            )
                          : Center( // 没有封面时的占位符
                              child: Icon(Icons.book_online, size: 50, color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.20)),
                            ),
                    ),
                  ),
                ),
              ),
            ),

            //书籍标题,其实要简洁点正式点标题应该没有，反正有封面就行了，但是实际上让一些根本不存在封面的东西不好办了
            Text(
              book.title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500, //稍微加粗一点
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),

            //阅读信息 (百分比)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Text(
                readingInfoText,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      )
    );
  }
}