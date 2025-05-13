import 'package:Tzz_Reader/main.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class FavoritesPage extends StatelessWidget {
  @override

  Widget build(BuildContext context) {
    var appStates = context.watch<MyAppState>();

    return Column(
      children: [
        // 标题
        Padding(
          padding: EdgeInsets.all(16),
          child: Text('You have ${appStates.favorites.length} favorites:'),
        ),
        // 两列网格布局
        Expanded(
          child: GridView.count(
            crossAxisCount: 2, // 每行2列
            mainAxisSpacing: 12, // 行间距
            crossAxisSpacing: 12, // 列间距
            padding: EdgeInsets.all(16), // 整体边距
            childAspectRatio: 0.8, // 调整宽高比（可选）
            children: [
              for (var msg in appStates.favorites)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4), // 卡片左右间距
                  child: FavoritesCard(pair: msg),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class FavoritesCard extends StatelessWidget {
  const FavoritesCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );


    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(pair.asLowerCase,style: style),
      ),
    );
  }
}


