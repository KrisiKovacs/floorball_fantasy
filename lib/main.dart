import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String htmlCode;

  @override
  void initState() {
    super.initState();
    htmlRead().then((value) => htmlCode = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: (htmlCode == null)
          ? Container()
          : Center(
              child: Text(htmlCode),
            ),
    );
  }

  Future<String> htmlRead() async {
    var document;

    var response = await http.get(Uri.parse("http://hunfloorball.hu/index.php?ch_id=2&pg=floorball_matches&year=2021"));
    if (response.statusCode == 200) {
      document = response.body;
    }
    return document;
  }
//class AppState extends State<App> {
//    void HttpRequestCode() {
//      get('http://hunfloorball.hu/index.php?ch_id=2&pg=floorball_matches&year=2021')
}
//  }
//}
