import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const MyHomePage(title: 'Pocket Dictionary'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _search = '';
  String result = 'Enter a word..';
  TextEditingController controller = TextEditingController();

  void _setSearch() async {
    setState(() {
      _search = controller.text;
    });
    if (_search != "") {
      getResult();
    } else {
      result = 'Please Enter a Search word..';
    }
  }

  getResult() async {
    String _result = '';
    try {
      var searchResult = await http.get(
          Uri.https("api.dictionaryapi.dev", "api/v2/entries/en/" + _search));
      var jsonData = jsonDecode(searchResult.body);
      // print(searchResult.statusCode);
      if (searchResult.statusCode != 404) {
        _result = jsonData[0]['meanings'][0]['definitions'][0]['definition'];
        print(_result);
      } else {
        _result = 'Word Not Found 😅';
        print(_result);
      }
    } catch (e) {
      print(e.toString());
    }
    setState(() {
      result = _result;
      _search = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unnecessary_const
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.40,
                  child: Image.asset('assets/love.png')),
            ),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Search',
                hintText: 'Enter Your Search',
              ),
            ),
            Padding(
                padding: const EdgeInsets.all(10.0),
                child: IconButton(
                  icon: Image.asset('assets/search.gif'),
                  iconSize: 50,
                  onPressed: () {
                    _setSearch();
                    // getResult();
                  },
                  tooltip: 'Search',
                )),
            Card(
              elevation: 3.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(result,
                        style: const TextStyle(
                            fontSize: 20.0, fontWeight: FontWeight.bold))),
              ),
            ),

            //       Padding(
            //   padding: EdgeInsets.all(8.0),
            //   child: TextField(
            //     maxLines: 8,
            //     decoration: InputDecoration.collapsed(hintText: "Enter your text here"),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
