import 'package:notesy/res/res.dart';

class NotesProvider with ChangeNotifier {
  final List<Note> _notes = Note().dummyNotes();
  List<Note> get notes => _notes;

  void add(Note note) {
    _notes.add(note);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void remove(Note note) {
    _notes.remove(note);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
