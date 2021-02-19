import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/firebaseProvider.dart';
import '../Models/models.dart';
import './drawer.dart';
import '../widgets/bookTile.dart';

import './addBookScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController _controller;
  var _onlyShowFavorite = false;
  @override
  void initState() {
    Provider.of<FirebaseProvider>(context, listen: false).signIn();
    Provider.of<FirebaseProvider>(context, listen: false).loadBooks();
    _controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build of main screen called');

    final _screenWidth = MediaQuery.of(context).size.width; //TODO change this to layout builder
    return Scaffold(
      drawer: CustomDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AddBookScreen.routeName),
        child: const Icon(Icons.add),
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            actions: [
              PopupMenuButton(
                onSelected: (SortOption sort) {
                  if (sort == SortOption.favorite) {
                    setState(() {
                      _onlyShowFavorite = !_onlyShowFavorite;
                      context.read<FirebaseProvider>().toggleFavorites();
                    });
                  }
                  context.read<FirebaseProvider>().sortBooks(sort);
                },
                itemBuilder: (context) => <PopupMenuEntry<SortOption>>[
                  PopupMenuItem(
                    value: SortOption.favorite,
                    child: Chip(
                      label: Text(!_onlyShowFavorite ? 'Only Show favorite' : 'Show all books'),
                    ),
                  ),
                  const PopupMenuItem(
                    value: SortOption.title,
                    child: Text('Sort by Title'),
                  ),
                  const PopupMenuItem(
                    value: SortOption.author,
                    child: Text('Sort by Author'),
                  ),
                  const PopupMenuItem(
                    value: SortOption.grade,
                    child: Text('Sort by Grade'),
                  ),
                  const PopupMenuItem(
                    value: SortOption.type,
                    child: Text('Sort by Type'),
                  ),
                ],
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Colors.orange,
                height: 4.0,
              ),
            ),

            //flexibleSpace: ,
            title: Container(
              // color: Colors.blue,
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: const EdgeInsets.all(8),
                width: _screenWidth * 0.6,
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  //border: Border.all(width: 3, color: Colors.white),
                ),
                child: TextField(
                  controller: _controller,
                  onChanged: (newValue) {
                    context.read<FirebaseProvider>().changeSearchString(newValue);
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintStyle: TextStyle(color: Colors.white),
                    hintText: 'Search',
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                    contentPadding: EdgeInsets.all(30),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            floating: true,
          ),
          Consumer<FirebaseProvider>(
            builder: (context, value, _) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => BookTile(value.books[index]),
                  childCount: value.books.length,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
