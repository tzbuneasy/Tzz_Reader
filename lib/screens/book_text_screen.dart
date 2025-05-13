import 'package:flutter/material.dart';



class BookTextViewer extends StatefulWidget {
  final String textContent; //书籍文本
  final String textTitle;
  const BookTextViewer({Key? key ,
                       required this.textTitle,
                       required this.textContent
                       }) : super(key: key);

  @override
  _BookTextViewerState createState() => _BookTextViewerState();

}

class _BookTextViewerState extends State<BookTextViewer> {
  final ScrollController _scrollController = ScrollController();
  double _fontSize = 16.0; //默认字体大小
  String _fontFamily = 'Wenjing'; //默认字体


  @override
  void initState() {
    super.initState();
    //初始化相关代码
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //对字体大小的控制
  void _increaseFontSize() {
    setState(() {
      if(_fontSize < 24.0){
        _fontSize += 2.0;
      }
    });
  }

  void _decreaseFontSize() {
    setState(() {
      if(_fontSize > 10.0) {
        _fontSize -= 2.0;
      }
    });
  }

  //更改字体的方法
  void _changeFontFamily(String fontFamily) {
    setState(() {
      _fontFamily = fontFamily;
    });
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // 顶部导航栏
      appBar: AppBar( 
        title: Text(
          widget.textTitle,
          style: TextStyle(
            fontSize: 14.0, //标题字体大小，应该小一点好
          ),
          ), // 页面标题

        //一些细节的调整
        surfaceTintColor: Colors.transparent, //Appbar背景透明,不然太不和谐了
        //surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        toolbarHeight: 36.0, //导航栏高度,

        actions: [
          // 添加一些操作按钮，例如调整字体大小、字体类型等
          IconButton(
            icon: const Icon(Icons.font_download),
            onPressed: () {
              
              _changeFontFamily('Wenjing');
            },
            tooltip: '切换字体',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: _increaseFontSize,
            tooltip: '增大字体',
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: _decreaseFontSize,
            tooltip: '减小字体',
          ),
        ],
      ),


      //页面内容
      body: GestureDetector(
        child: Scrollbar(
          controller: _scrollController, //传递滚动条状态
          thumbVisibility: true, //滚动条显示
        
          //使用SizedBox强制沾满整个空间，否则文本过少时会自动收缩
          child: SizedBox(
            width: double.infinity, // 确保滚动条覆盖整个宽度
            
            //使内容可以滚动
            child: SingleChildScrollView(
              controller: _scrollController, //使用同一个controller
        
              //主页面内容
              child:Padding(
                padding: const EdgeInsets.all(16.0), //边距
        
                //文本
                child:Text(
                  widget.textContent, // 显示传入的书籍文本
        
                  //具体样式调整
                  style: TextStyle(
                    fontSize: _fontSize, // 应用当前的字体大小 
                    fontFamily: _fontFamily, // 应用当前的字体 
                    height: 1.5, //行高
                  ),
                  textAlign: TextAlign.justify, // 文本对齐方式,两端对其
        
                ),
        
              ),
        
             ), 
        
          )
          
        ),
      ),




      //暂时没什么必要的功能
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     _scrollController.animateTo(
      //       0.0, // 滚动到顶部
      //       duration: const Duration(milliseconds: 500), // 动画时长
      //       curve: Curves.easeInOut, // 动画曲线
      //     );
      //   },
      //   tooltip: '返回顶部',
      //   child: const Icon(Icons.arrow_upward),
      // ),
    );
  }

  
}