// lib/models/book_info.dart
import 'package:yaml/yaml.dart';

class BookInfo {
  final String title; // 标题（书名）
  final String? author; //作者
  final String? coverAssetPath; // 封面图片路径
  final String contentAssetPath; //书籍内容文件路径
  final double? readingPercentage; // 新增：阅读百分比 (例如 0.75 代表 75%)

  BookInfo({
    required this.title,
    this.author,
    this.coverAssetPath,
    required this.contentAssetPath,
    this.readingPercentage, // 新增
  });


  //使用yaml构造Bokkinfo的工厂方法
  factory BookInfo.fromYaml(YamlMap yamlMap) {
    double? percentage;
    if (yamlMap['reading_percentage'] != null) {
      // 尝试将各种可能的数字类型或字符串转换为 double
      var rawPercentage = yamlMap['reading_percentage'];
      if (rawPercentage is num) {
        percentage = rawPercentage.toDouble();
      } else if (rawPercentage is String) {
        percentage = double.tryParse(rawPercentage);
      }
    }

    return BookInfo(
      title: yamlMap['title'] ?? '未知标题',
      author: yamlMap['author'],
      coverAssetPath: yamlMap['cover_asset_path'],
      contentAssetPath: yamlMap['content_asset_path'] ?? '',
      readingPercentage: percentage, // 新增
    );
  }
}