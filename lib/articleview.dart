import 'package:flutter/material.dart';
import 'article.dart';

class ArticleView extends StatelessWidget {
  const ArticleView(
      {Key? key,
      required this.title,
      required this.description,
      required this.body,
      required this.section})
      : super(key: key);
  final String title;
  final String body;
  final String description;
  final String section;

  @override
  Widget build(BuildContext context) {
    var article = Article(body);
    var elements = article.getElements();

    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
            alignment: Alignment.center,
            child: Container(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: elements.length,
                  itemBuilder: (context, index) {
                    var e = elements[index];
                    return Container(
                        padding: const EdgeInsets.all(5.0), child: e);
                  },
                ))));
  }
}
