enum Status {
  notStarted,
  reading,
  done,
}

class Book {
  String id;
  String title;
  String author;
  String description;
  String type;
  int eval;
  bool isFavorite;
  Status status;
  int page;

  Book(
      {this.id,
      this.title,
      this.author,
      this.description,
      this.eval,
      this.isFavorite = false,
      this.type,
      this.page = 0,
      this.status = Status.notStarted});
}
