import 'package:flutter/material.dart';
import 'contentstack.dart';
import 'news_details.dart';

class NewsPage extends StatefulWidget {

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  var newsList = [];

  bool isDataAvailable = false;

  //using contentstack-dart-sdk to fetch the news content
   _getNews() async {

    // initialise contentstack by providing credentials as shown below. 
    var stack = Contentstack.stack( apiKey: '***REMOVED***', 
    accessToken: '***REMOVED***', environment: 'production');

    // get entry instance as shown below.
    Entry entry = stack.contentType('news').entry();
    // find all the entries as shown below.
    // In case you want to filter the entries, do provide key value pair in find method as parameter
    var response =  await entry.find({});
    // checks if response is not null and not empty.
    if (response!=null && response.isNotEmpty){
      print(response.containsKey('entries'));
      //parse entries from the response. as shown below.
      var resp = response['entries'];
      isDataAvailable = true;
      // update the response so UI can update accordingly.
      setState(() {
        newsList = resp;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // get news response.
    _getNews();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('News', style: TextStyle(color: Colors.white, fontSize: 25, fontFamily: 'nunito' ),), centerTitle: true,
      ),

      body:  isDataAvailable ? Feeds(newsList: newsList) : Center(child: CircularProgressIndicator())
    );
  }
}


class Feeds extends StatelessWidget {

  const Feeds({
    Key key,
    @required this.newsList,
  }) : super(key: key);

  final List newsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(8),
      itemCount: newsList.length,
      itemBuilder: (BuildContext context, int index) {

        return Card(
          elevation: 4,
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailScreen(
                          newsTitle: newsList[index]['title'],
                          newsDetail: newsList[index]['body'],
                        )),
              );
            },
            title: Text(
              newsList[index]['title'], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
            ),
            leading: CircleAvatar(
              radius: 25.0,
              backgroundImage: AssetImage('assets/red_logo.png'),
              backgroundColor: Colors.transparent,
            ),
            subtitle: Container(
              padding: EdgeInsets.all(4),
              child: Text(
                newsList[index]['body'], style: TextStyle(fontSize: 15),
                maxLines: 2,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[600],
            ),
          ),
        );
      },
    );
  }
}
