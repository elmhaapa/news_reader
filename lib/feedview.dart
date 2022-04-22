import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:webfeed/webfeed.dart';
import 'articleview.dart';

class FeedView extends StatefulWidget {
  const FeedView({Key? key, required this.url, required this.section})
      : super(key: key);
  final String url;
  final String section;

  @override
  State<FeedView> createState() => _FeedView();
}

class _FeedView extends State<FeedView> {
  late Future<RssFeed> feed;
  @override
  void initState() {
    super.initState();
    feed = fetchData(widget.url);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<RssFeed>(
        future: feed,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          }
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.items?.length ?? 0,
                itemBuilder: (context, index) {
                  var item = snapshot.data!.items?[index];
                  var title = item?.title ?? '';
                  var description = item?.description ?? '';
                  var body = item?.content?.value ?? '';

                  return ListTile(
                    title: Text(title),
                    subtitle: Text(description),
                    onTap: () => {
                      Navigator.push(context,
                          MaterialPageRoute<ArticleView>(builder: (context) {
                        return ArticleView(
                            title: title,
                            description: description,
                            body: body,
                            section: widget.section);
                      }))
                    },
                  );
                });
          }
          return Center(
              child: Container(
                  width: 20.0,
                  height: 20.0,
                  child: const CircularProgressIndicator()));
        });
  }
}

Future<RssFeed> fetchData(url) async {
  final response = await get(Uri.parse(url));
  if (response.statusCode == 200) {
    return RssFeed.parse(response.body);
  } else {
    throw Exception("Couldn't load data!");
  }
}
