import 'package:contentstack_flutter_news_app/news.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.red,
          brightness: Brightness.dark,
          accentColor: Colors.orange,
          fontFamily: 'nunito'),
      home: NewsPage(),
    ));

