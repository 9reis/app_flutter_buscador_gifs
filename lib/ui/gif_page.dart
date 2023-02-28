import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {
  const GifPage(this._gifData, {Key? key}) : super(key: key);

  final Map _gifData;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData['title']),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
              icon: Icon(Icons.share),
              //Compartilhar o gif
              onPressed: () {
                Share.share(_gifData['images']['fixed_height']['url']);
              }),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData['images']['fixed_height']['url']),
      ),
    );
  }
}
