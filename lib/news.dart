import 'package:flutter/material.dart';
import 'contentstack.dart';
import 'news_details.dart';

class NewsPage extends StatefulWidget {

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  Map entryList = {};

  //using contentstack-dart-sdk to fetch the news content
   _getData() async {
    var stack = Contentstack.stack( apiKey: 'blt920bb7e90248f607', accessToken: 'blt0c4300391e033d4a59eb2857', environment: 'production');
    Entry entry = stack.contentType('news').entry();
    Map response =  await entry.find({});
    if (response!=null && response.isNotEmpty){
      print(response.containsKey('entries'));
      var resp = response['entries'];
      setState(() {
        entryList = resp;
      });
    }else{
      print('Error');
    }

    return entryList;
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text('News'), centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: entryList.length,
        itemBuilder: (BuildContext context, int index) {

          return Card(
            elevation: 2,
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            newsTitle: entryList[index]['title'],
                            newsDetail: entryList[index]['body'],
                          )),
                );
              },
              title: Text(
                entryList[index]['title'],
                maxLines: 1,
              ),
              leading: CircleAvatar(
                radius: 25.0,
                backgroundImage: AssetImage('assets/logo.jpg'),
                //backgroundColor: Colors.transparent,
              ),
              subtitle: Container(
                padding: EdgeInsets.all(4),
                child: Text(
                  entryList[index]['body'],
                  maxLines: 1,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[600],
              ),
            ),
          );
        },
      ),
    );
  }
}
