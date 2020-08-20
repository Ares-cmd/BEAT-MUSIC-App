class Song {
  String title;
  String duration;
  String id;

  Song({this.title, this.duration, this.id});

  @override
  String toString() {
    return 'Song{title: $title, duration: $duration,}';
  }
}
