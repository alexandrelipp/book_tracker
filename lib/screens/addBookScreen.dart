import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/firebaseProvider.dart';
import '../Models/models.dart';


import '../widgets/textFormWithIcon.dart';

class AddBookScreen extends StatefulWidget {
  static const routeName = '/addBookScreen';

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  var _isLoading = false;
  final _favSelections = [true, false];
  final _statusSelections = [true, false, false];
  var _statusColor = Colors.red;
  Book book = Book();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    print('build of add called');
    return Scaffold(
      resizeToAvoidBottomPadding: false, //prevent add button to be on top of keyboard
      appBar: AppBar(
        title: const Text('Add book'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TextFormWithIcon(
                      Icons.title,
                      'Title*',
                      validator: (String value) {
                        if (value.length < 2) return 'Please provide a title that is at least 2 characters long';
                        return null;
                      },
                      onSave: (String value) {
                        book.title = value;
                      },
                    ),
                    TextFormWithIcon(
                      Icons.person,
                      'Author',
                      onSave: (String value) {
                        if (value != null) {
                          book.author = value;
                        }
                      },
                    ),
                    TextFormWithIcon(
                      Icons.category,
                      'Type',
                      onSave: (String value) {
                        if (value != null) {
                          book.type = value;
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (value) {
                          book.eval = int.parse(value);
                        },
                        validator: (value) {
                          final number = int.tryParse(value);
                          if (number == null) {
                            return 'Please provide a number';
                          }
                          if (number < 0 || number > 100) {
                            return 'Please provide a number in range of 0 and 100';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: const InputDecoration(
                          suffixText: '/100',
                          filled: true,
                          labelText: 'Grade',
                          icon: Icon(Icons.grade),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (value) {
                          if (value != null) {
                            book.description = value;
                          }
                        },
                        textInputAction: TextInputAction.newline,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description',
                          helperMaxLines: 2,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: ToggleButtons(
                          borderWidth: 3.0,
                          selectedBorderColor: Colors.red,
                          selectedColor: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                          children: [
                            const SizedBox(
                              width: 100,
                              child: Icon(
                                Icons.favorite_border,
                              ),
                            ),
                            const SizedBox(
                              width: 100,
                              child: Icon(Icons.favorite),
                            ),
                          ],
                          isSelected: _favSelections,
                          onPressed: (index) {
                            book.isFavorite = !(index == 0);
                            setState(() {
                              _favSelections[0] = !_favSelections[0];
                              _favSelections[1] = !_favSelections[1];
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: LayoutBuilder(builder: (context, contraints) {
                          return ToggleButtons(
                            selectedColor: Colors.black,
                            selectedBorderColor: _statusColor,
                            borderWidth: 3.0,
                            borderRadius: BorderRadius.circular(20),
                            children: [
                              SizedBox(
                                width: contraints.maxWidth * 0.32,
                                child: Text(
                                  'Not Started',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(),
                                ),
                              ),
                              SizedBox(
                                width: contraints.maxWidth * 0.32,
                                child: Text(
                                  'Reading',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(
                                width: contraints.maxWidth * 0.32,
                                child: Text(
                                  'Done',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                            isSelected: _statusSelections,
                            onPressed: (index) {
                              setState(() {
                                for (var i = 0; i < 3; i++) {
                                  if (i == index) {
                                    _statusSelections[i] = true;
                                  } else {
                                    _statusSelections[i] = false;
                                  }
                                }
                                switch (index) {
                                  case 0:
                                    _statusColor = Colors.red;
                                    book.status = Status.notStarted;
                                    break;
                                  case 1:
                                    _statusColor = Colors.yellow;
                                    book.status = Status.reading;
                                    break;
                                  case 2:
                                    _statusColor = Colors.green;
                                    book.status = Status.done;
                                    break;
                                  default:
                                    _statusColor = Colors.green;
                                }
                              });
                            },
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        onSaved: (value) {
                          book.page = int.parse(value);
                        },
                        initialValue: '0',
                        validator: (value) {
                          final number = int.tryParse(value);
                          if (number == null) {
                            return 'Please provide a number';
                          }
                          if (number < 0) {
                            return 'Please provide a number greater then 0';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Current Page',
                          icon: const Icon(Icons.menu_book_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      _isLoading = true;
                    });
                    _formKey.currentState.save();
                    await context.read<FirebaseProvider>().addBook(book);

                    Navigator.of(context).pop('added');
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  width: double.infinity,
                  height: 45,
                  child: Center(
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            backgroundColor: Colors.white,
                          )
                        : const Text('Add book'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
