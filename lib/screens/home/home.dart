import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String finalImages = '';
  TextEditingController texttoImage = TextEditingController();
  // final apiKeys = "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";

  Future<void> genrateAIImage(String value) async {
     setState(() {
        finalImages = '';
      });
    final url = Uri.parse("https://api.openai.com/v1/images/generations");
    final headers = {
      "Content-Type":"application/json",
      "Authorization":"Bearer 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"
    };

    var response = await http.post(url, headers:headers, body: jsonEncode({"prompt":value, "n":1, "size":'256x256'}));
    print(response);
    if(response.statusCode == 200){
      var responsedecode = jsonDecode(response.body);
      print(responsedecode['data'][0]['url'].toString());
      // finalImages = responsedecode['data'][0]['url'];
      setState(() {
        finalImages = responsedecode['data'][0]['url'];
      });
    }else{
       print("Failed to genrate image");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Open AI"),
        elevation: 0,
      ),
      body: Container(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
                controller: texttoImage,
                onSubmitted: (value) async {
                 await genrateAIImage(value);
                },
                decoration: InputDecoration(
                  hintText: "Enter Text to Generate AI Image",
                  filled: true,
                  fillColor: Colors.blue.shade100,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                  suffixIcon: IconButton(icon: const Icon(Icons.clear, color: Colors.black), onPressed: () {}, ),
                  prefixIcon:  IconButton(icon: const Icon(Icons.search, color: Colors.black), onPressed: () {}, ),
                ),
            ),
          ),
          

          Container(
            padding: const EdgeInsets.all(10),
            height: 400,
            child: finalImages !='' ? Image.network(finalImages, width: 256, height: 256,) : const Text("Please enter text to Genearte Ai Image"),
          )
        ],)
      ),
    );
  }
}