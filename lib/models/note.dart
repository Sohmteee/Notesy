import 'package:notesy/res/res.dart';
part 'note.g.dart';

@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String content;

  @HiveField(2)
  final DateTime date;

  Note({
    this.title = '',
    this.content = '',
    DateTime? date,
  }) : date = date ?? DateTime.now();

  Note copyWith({
    String? title,
    String? content,
    DateTime? date,
  }) {
    return Note(
      title: title ?? this.title,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Note &&
        other.title == title &&
        other.content == content &&
        other.date == date;
  }

  @override
  int get hashCode => title.hashCode ^ content.hashCode ^ date.hashCode;

  @override
  String toString() => 'Note title: $title, content: $content, date: $date';

  Note.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        content = json['content'],
        date = DateTime.parse(json['date'])
    ;

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'date': date.toIso8601String(),
      };

  static List<Note> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => Note.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<Note> notes) {
    return notes.map((note) => note.toJson()).toList();
  }

  String monthToString() {
    switch (date.month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  String dateToString() {
    return '${monthToString()} ${date.day}, ${date.year}';
  }

  List<Note> dummyNotes() => List.generate(
        10,
        (index) => Note(
          title: 'Note Title ${10 - index}',
          content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
          date: DateTime.now().subtract(Duration(days: 10 - index - 1)),
        ),
      );
}
