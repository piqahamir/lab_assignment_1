import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MOVIE NAME',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MY Movie'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController newtxt = TextEditingController();

  String desc = "";
  var posterFilm = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SingleChildScrollView(
          reverse: true,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text("MOVIE NAME",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              TextField(
                controller: newtxt,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    hintText: 'Enter Movie Name',
                    suffixIcon: IconButton(
                      onPressed: () => newtxt.clear(),
                      icon: const Icon(Icons.clear),
                    )),
                keyboardType: TextInputType.text,
              ),
              ElevatedButton(onPressed: getfilm, child: const Text("Search")),
              Text(
                desc,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
              Image.network(
                posterFilm,
                height: 250,
                width: 250,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                      height: 250,
                      width: 250,
                      fit: BoxFit.cover,
                      'assets/images/movieposter.jpg');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  getfilm() async {
    var apiid = "caee97b";
    var newtext = newtxt.text;
    var url = Uri.parse('http://www.omdbapi.com/?t=$newtext&apikey=$apiid');
    var response = await http.get(url);
    var rescode = response.statusCode;

    if (rescode == 200) {
      var jsonData = response.body;
      var parsedJson = json.decode(jsonData);
      var poster = parsedJson["Poster"];

      setState(() {
        var title = parsedJson["Title"];
        var genre = parsedJson["Genre"];
        var actors = parsedJson["Actors"];
        var plot = parsedJson["Plot"];

        posterFilm = "$poster";
        desc = "$title \n $genre \n $actors \n\n$plot\n";

        Fluttertoast.showToast(
          msg: "Movie Found",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 20,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 20,
        );
      });
    } else {
      setState(() {
        desc = "No record";
      });
    }
  }
}
