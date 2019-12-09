import 'package:flutter/material.dart';
import 'contentstack.dart';
import 'news_details.dart';

class NewsPage extends StatefulWidget {

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  var entryList = [];
  var imageUrl = 'https://pbs.twimg.com/profile_images/944044690185134080/dxAswGWd_400x400.jpg';

  // using contentstack-dart-sdk to fetch the news content
  _getData() async {
    var stack = Contentstack.stack(
        apiKey: 'blt920bb7e90248f607',
        accessToken: 'blt0c4300391e033d4a59eb2857',
        environment: 'production');
    Entry entry = stack.contentType('news').entries();
    Map response = await entry.find({});
    var resp = response['entries'];

    setState(() {
      print('received entries');
      entryList = resp;
    });

    return response;
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
        actions: <Widget>[
          Container(
            padding: EdgeInsets.all(8),

//            child: RaisedButton(
//              onPressed: _changeBrightness(),
//            ),

          )
        ],
        title: Text('News'),
        centerTitle: true,
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
                backgroundImage: NetworkImage(imageUrl),
                backgroundColor: Colors.transparent,
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
