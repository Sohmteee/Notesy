import 'package:notesy/res/res.dart';

class NotesProvider with ChangeNotifier {
  final List<Note> _notes = Note().dummyNotes();
  List<Note> get notes {
    return _notes..sort((a, b) => b.date.compareTo(a.date));
  }

  List<Note> _selectedNotes = [];
  List<Note> get selectedNotes => _selectedNotes;
  

  void add(Note note) {
    _notes.add(note);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void update(Note currentNote, Note newNote) {
    final index = _notes.indexOf(currentNote);
    if (index == -1) {
      add(newNote);
      return;
    }
    _notes[index] = newNote;
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

  void toggleSelected(Note note) {
    if (_selectedNotes.contains(note)) {
      removeSelected(note);
    } else {
      addSelected(note);
    }
  }

  void addSelected(Note note){
    _selectedNotes.add(note);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void removeSelected(Note note) {
    _selectedNotes.remove(note);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
