import 'dart:convert';

import 'package:app_flutter_buscador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
// import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null) {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/trending?api_key=BPSF8x3gOxlbQZ1eig9sqROD8PGjn3bd&limit=20&rating=g"));
    } else {
      response = await http.get(Uri.parse(
          "https://api.giphy.com/v1/gifs/search?api_key=BPSF8x3gOxlbQZ1eig9sqROD8PGjn3bd&q=$_search&limit=19&offset=$_offset&rating=g&lang=en"));
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                  // Resetar ao psq, caso contrario nao mostra os primeiros itens da nova pesquisa
                  _offset = 0;
                });
              },
              decoration: const InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
              child: FutureBuilder(
                  future: _getGifs(),
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                          width: 200,
                          height: 200,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 5,
                          ),
                        );
                      default:
                        if (snapshot.hasError)
                          return Container();
                        else
                          return _createGifTable(context, snapshot);
                    }
                  })),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      // Como os itens serão organizados na tela
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10, //Espaço Horizontal entre os itens
        mainAxisSpacing: 10, // Espaço Vertical entre os itens
      ),
      itemCount: _getCount(snapshot.data['data']),
      // Func que cria cada item do grid
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data['data'].length)
          //Permite clicar no item
          return GestureDetector(
            child: Image.network(
              snapshot.data['data'][index]['images']['fixed_height']['url'],
              height: 300,
              fit: BoxFit.cover,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GifPage(
                    snapshot.data['data'][index],
                  ),
                ),
              );
            },
            onLongPress: () {
              Share.share(snapshot.data['data'][index]['images']['fixed_height']
                  ['url']);
            },
          );
        else
          return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.add, color: Colors.white, size: 70),
                  Text("Carregar mais ...",
                      style: TextStyle(color: Colors.white, fontSize: 22))
                ],
              ),
              onTap: () {
                setState(() {
                  _offset += 19;
                });
              },
            ),
          );
      },
    );
  }
}
