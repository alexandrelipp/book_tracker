import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/models.dart';

enum SortOption {
  title,
  author,
  grade,
  type,
  favorite,
}

class FirebaseProvider with ChangeNotifier {
  String userUID;
  var _books = <Book>[];
  String _searchString = '';
  bool _onlyShowFavorite = false;

  int get nBooks => _books.length;

  void changeSearchString(String newSearchSting) {
    _searchString = newSearchSting;
    notifyListeners();
    print(_searchString);
  }

  void toggleFavorites() {
    _onlyShowFavorite = !_onlyShowFavorite;
    notifyListeners();
  }

  List<Book> get books {
    if (!_onlyShowFavorite) {
      return _searchString.isEmpty
          ? [..._books]
          : [..._books.where((book) => book.title.contains(_searchString) || book.author.contains(_searchString))];
    }
    return _searchString.isEmpty
        ? [..._books.where((book) => book.isFavorite)]
        : [
            ..._books.where((book) =>
                book.isFavorite && (book.title.contains(_searchString) || book.author.contains(_searchString)))
          ];
  }

  //  => _searchString.isEmpty
  //     ? [..._books]
  //     : [..._books.where((book) => book.title.contains(_searchString) || book.author.contains(_searchString))];

  // List<Book> get favoritesBooks => _searchString.isEmpty
  //     ? [..._books.where((book) => book.isFavorite)]
  //     : [
  //         ..._books.where(
  //             (book) => book.isFavorite && (book.title.contains(_searchString) || book.author.contains(_searchString)))
  //       ];

  Future<void> signIn() async {
    userUID = FirebaseAuth.instance.currentUser.uid;
  }

  Future<void> signOut() async {
    _books.clear();
    userUID = '';
    await FirebaseAuth.instance.signOut();
  }

  void sortBooks(SortOption sort) {
    switch (sort) {
      case SortOption.title:
        _books.sort((a, b) => a.title.compareTo(b.title));
        break;
      case SortOption.author:
        _books.sort((a, b) {
          if ((a.author == '') && (b.author == '')) return 0;
          if (a.author == '') return 1;
          if (b.author == '') return -1;
          return a.author.compareTo(b.author);
        });
        break;
      case SortOption.grade:
        _books.sort((b, a) => a.eval.compareTo(b.eval));
        break;
      case SortOption.type:
        _books.sort((a, b) {
          if ((a.type == '') && (b.type == '')) return 0;
          if (a.type == '') return 1;
          if (b.type == '') return -1;
          return a.type.compareTo(b.type);
        });
        break;
      default:
    }
    notifyListeners();
  }

  Future<void> loadBooks() async {
    var temp = <Book>[];
    var data = await FirebaseFirestore.instance.collection('users/$userUID/books').get();
    temp = data.docs.map((queryDocumentSnapshot) {
      final bookInfo = queryDocumentSnapshot.data();
      Status bookstatus;
      switch (bookInfo['status'] as String) {
        case 'reading':
          bookstatus = Status.reading;
          break;
        case 'botStarted':
          bookstatus = Status.notStarted;
          break;
        case 'done':
          bookstatus = Status.done;
          break;
        default:
          bookstatus = Status.notStarted;
      }
      return Book(
        id: queryDocumentSnapshot.id,
        title: bookInfo['title'] as String,
        type: bookInfo['type'] as String,
        author: bookInfo['author'] as String,
        description: bookInfo['description'] as String,
        isFavorite: bookInfo['isFavorite'] as bool,
        eval: bookInfo['eval'] as int,
        page: bookInfo['book'] as int,
        status: bookstatus,
      );
    }).toList();
    _books = [...temp];
    notifyListeners();
  }

  Future<bool> addBook(Book book) async {
    print('here in add bookd');
    try {
      var documentReference = await FirebaseFirestore.instance.collection('users/$userUID/books').add({
        'title': book.title,
        'author': book.author,
        'description': book.description,
        'type': book.type,
        'eval': book.eval,
        'isFavorite': book.isFavorite,
        'status': book.status.toString().split('.').last,
        'page': book.page,
      });
      book.id = documentReference.id;
      _books.add(book);
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> changeStatus(String bookId, Status newStatus) async {
    final status = newStatus.toString().split('.').last;
    await FirebaseFirestore.instance.doc('users/$userUID/books/$bookId').update({
      'status': status,
    });
  }

  Future<void> toggleFavorite(String bookId, {@required bool isFavorite}) async {
    await FirebaseFirestore.instance.doc('users/$userUID/books/$bookId').update({
      'isFavorite': isFavorite,
    });
  }
}
