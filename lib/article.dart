import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' as parser;
import 'package:flutter/material.dart';
import 'option.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

const fontSizeH3 = 18.0;
const parsingError = "Failed to parse the rss feed.";

class Article {
  final String document;
  final Option<dom.Document> parsedDocument;
  Article(this.document)
      : parsedDocument = tryGet(() => parser.parse(document));

  List<Widget> getElements() {
    final body = parsedDocument
        .flatMap((d) => tryGet(() => d.getElementsByTagName("body")[0]));
    if (body.isEmpty()) {
      return [const Center(child: Text(parsingError))];
    } else {
      return body
          .get()
          .children
          .map(getWidget)
          .expand((e) => e.toIterable())
          .toList();
    }
  }
}

Option<Widget> getWidget(dom.Element e) {
  switch (e.localName) {
    case "p":
      return Option(paragraph(e));
    case "h3":
      return Option(h3(e.text));
    case "figure":
      return Option(imageWidget(e));
    default:
      return Option.empty();
  }
}

Widget imageWidget(dom.Element e) {
  final imageAndCaption =
      e.children.fold<List<Widget>>([], (List<Widget> prev, dom.Element e) {
    if (e.localName == "img") {
      return [...prev, image(e.attributes["src"] ?? '')];
    }
    if (e.localName == "figcaption") {
      return [...prev, caption(e.text)];
    }
    return prev;
  });
  return Center(child: Column(children: imageAndCaption));
}

Widget caption(String text) {
  return Container(
      child: RichText(
          text: TextSpan(
              text: text,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.normal))),
      padding: const EdgeInsets.all(10.0));
}

Widget image(String src) {
  return Container(
      child: Image(image: NetworkImage("https:$src")),
      padding: const EdgeInsets.all(10.0));
}

Widget h3(String text) {
  return RichText(
      text: TextSpan(
          text: text,
          style: const TextStyle(
              color: Colors.black,
              fontSize: fontSizeH3,
              fontWeight: FontWeight.bold)));
}

TextSpan pNormal(String text) {
  return TextSpan(
      text: text,
      style:
          const TextStyle(fontWeight: FontWeight.normal, color: Colors.black));
}

TextSpan pEm(String text) {
  return TextSpan(
      text: text,
      style: const TextStyle(
          fontWeight: FontWeight.normal,
          fontStyle: FontStyle.italic,
          color: Colors.black));
}

TextSpan pStrong(String text) {
  return TextSpan(
      text: text,
      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black));
}

TextSpan pLink(String text, String href) {
  return TextSpan(
      text: text,
      style: const TextStyle(fontWeight: FontWeight.normal, color: Colors.blue),
      recognizer: TapGestureRecognizer()
        ..onTap = () {
          launch(href);
        });
}

List<TextSpan> Function(TextSpan x) insertInBetween(dom.Element child) {
  final midText = child.text;
  final tag = child.localName ?? '';
  return (TextSpan x) {
    final _text = x.text ?? '';
    final ll = _text.split(midText);
    if (ll.length > 1) {
      final first = ll[0];
      final second = ll[1];
      switch (tag) {
        case 'a':
          {
            return [
              pNormal(first),
              pLink(midText, child.attributes['href'] ?? ''),
              pNormal(second)
            ];
          }
        case 'strong':
          return [pNormal(first), pStrong(midText), pNormal(second)];
        case 'em':
          return [pNormal(first), pEm(midText), pNormal(second)];
        default:
          return [pNormal(first), pNormal(midText), pNormal(second)];
      }
    }
    return ll.map((elem) => pNormal(elem)).toList();
  };
}

Widget paragraph(dom.Element e) {
  final wholeText = e.text;
  final orig = <TextSpan>[pNormal(wholeText)];
  final textInPieces =
      e.children.fold(orig, (List<TextSpan> prev, dom.Element child) {
    return prev
        .map(insertInBetween(child))
        .expand((element) => element)
        .toList();
  });

  return RichText(
      text: TextSpan(
          text: '',
          // style: DefaultTextStyle.of(context).style,
          children: textInPieces));
}
