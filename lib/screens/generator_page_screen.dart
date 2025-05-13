import 'package:Tzz_Reader/main.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class GeneratoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)){
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
    
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         
          BigCard(pair: pair),
          SizedBox(height: 10,),
      
          Row(
            mainAxisSize: MainAxisSize.min,

            children: [
              ElevatedButton.icon(
                onPressed: (){
                  appState.changeFavorites();
                },
                icon: Icon(icon),
                label: Text('Like'),

              ),
              SizedBox(width:10),
              ElevatedButton(
                onPressed: (){
                  appState.changeText();
                },
                child: Text('Next Word'),
              ),
            ],
          ),
        ],
      ),
    
    );
  }
  
}

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(pair.asLowerCase,style: style,),
      ),
    );
  }
}