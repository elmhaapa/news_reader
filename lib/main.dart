import 'package:flutter/material.dart';
import 'feedview.dart';
import 'urls.dart';

const title = 'YLE uutiset';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: title),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: feeds.keys.toList().length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final feedViews = feeds.keys.map((section) {
      return FeedView(url: feeds[section] ?? '', section: section);
    }).toList();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          bottom: TabBar(
              isScrollable: true,
              controller: _tabController,
              tabs: feeds.keys.map((section) => Tab(text: section)).toList()),
        ),
        body: TabBarView(
          controller: _tabController,
          children: feedViews,
        ));
  }
}
