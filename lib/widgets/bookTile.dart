import 'package:flutter/material.dart';
import 'package:simple_book_tracker/providers/firebaseProvider.dart';
import '../Models/models.dart';
import '../assets/constants.dart';
import 'package:provider/provider.dart';
import './errorDialog.dart';
import 'iconCircle.dart';

class BookTile extends StatefulWidget {
  final Book book;

  const BookTile(this.book, {Key key}) : super(key: key);
  @override
  _BookTileState createState() => _BookTileState();
}

class _BookTileState extends State<BookTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PopupMenuButton(
            //TODO check width of this button when clicked on
            onSelected: (Status newStatus) async {
              if (newStatus == widget.book.status) {
                return;
              }
              try {
                await context.read<FirebaseProvider>().changeStatus(widget.book.id, newStatus);
                setState(() {
                  widget.book.status = newStatus;
                });
              } catch (e) {
                await showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(),
                );
              }
            },
            itemBuilder: (context) => <PopupMenuEntry<Status>>[
              const PopupMenuItem(
                value: Status.done,
                child: IconCircle(Icons.library_add_check_rounded, Color(0xFF1B5E20)),
              ),
              const PopupMenuItem(
                value: Status.reading,
                child: IconCircle(Icons.menu_book_outlined, Colors.amber),
              ),
              const PopupMenuItem(
                value: Status.notStarted,
                child: IconCircle(Icons.library_books, Color(0xFFE57373)),
              ),
            ],
            child: IconCircle(
              widget.book.status == Status.done
                  ? Icons.library_add_check_rounded
                  : widget.book.status == Status.reading
                      ? Icons.menu_book_outlined
                      : Icons.library_books,
              widget.book.status == Status.done
                  ? const Color(0xFF1B5E20)
                  : widget.book.status == Status.reading
                      ? Colors.amber
                      : const Color(0xFFE57373),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.book.title,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (widget.book.author != '')
                  const SizedBox(
                    height: 5,
                  ),
                if (widget.book.author != '')
                  Row(
                    children: [
                      const Icon(Icons.person, size: 14),
                      Expanded(
                        child: Text(
                          widget.book.author,
                          overflow: TextOverflow.fade,
                          maxLines: 1,
                          softWrap: false,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                if (widget.book.type != '') Text(widget.book.type),
                Text('${widget.book.eval} /5'),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              // Navigator.of(context)
              //     .pushNamed(EditScreen.routeName, arguments: book);
            },
            child: Icon(
              Icons.edit,
              color: Colors.grey[600],
            ),
          ),
          IconButton(
            icon: Icon(
              widget.book.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: () async {
              try {
                await context
                    .read<FirebaseProvider>()
                    .toggleFavorite(widget.book.id, isFavorite: !widget.book.isFavorite);
                setState(() {
                  widget.book.isFavorite = !widget.book.isFavorite;
                });
              } catch (e) {
                print('nope');
              }
            },
          ),
        ],
        mainAxisSize: MainAxisSize.min,
      ),
    );
  }
}
