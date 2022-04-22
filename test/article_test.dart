import 'dart:io';
import 'package:yle_news/article.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  var documentBody = '';
  File('testarticle.xml').readAsString().then((String contents) {
    documentBody = contents;
  });
  test('Article is parsed to four elements', () async {
    final art = Article(documentBody);
    final elements = art.getElements();
    expect(elements.length, 4);
  });
}
