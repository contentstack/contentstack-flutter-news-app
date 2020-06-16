import 'package:flutter/material.dart';
import 'package:contentstack/contentstack.dart' as contentstack;
import 'news_details.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool isDataAvailable = false;
  var newsList = [];

  @override
  void initState() {
    super.initState();
    _getNews();
  }

  _getNews() async {
    final stack = contentstack.Stack(
        'blt7979d15c28261b93', 'cs17465ae5683299db9d259cb6', 'production');
    final query = stack.contentType('news').entry().query();
    await query.find().then((response) {
      isDataAvailable = true;
      setState(() {
        newsList = response['entries'];
      });
    }).catchError((error) {
      print(error.message.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'News',
            style: TextStyle(
                color: Colors.white, fontSize: 25, fontFamily: 'nunito'),
          ),
          centerTitle: true,
        ),
        body: isDataAvailable
            ? Feeds(newsList: this.newsList)
            : Center(child: CircularProgressIndicator()));
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
      itemCount: this.newsList.length,
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
              newsList[index]['title'],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                newsList[index]['body'],
                style: TextStyle(fontSize: 15),
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
