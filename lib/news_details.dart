import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailScreen extends StatelessWidget {
  final String newsTitle;
  final String newsDetail;

  DetailScreen({Key key, @required this.newsTitle, @required this.newsDetail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          newsTitle,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Card(
            elevation: 3,
            child: ListTile(

              subtitle: Container(
                padding: EdgeInsets.all(4),
                child: Html(
                  data: newsDetail,
                  shrinkToFit: true,
                  defaultTextStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
