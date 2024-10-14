import 'package:notesy/res/res.dart';

class NotesProvider with ChangeNotifier {
  int _pinLimit = 3;
  int get pinLimit => _pinLimit;
  set pinLimit(int pinLimit) {
    _pinLimit = pinLimit;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  final List<Note> _notes = box.get('notes', defaultValue: <Note>[]);
  List<Note> get notes {
    return _notes..sort((a, b) => b.date.compareTo(a.date));
  }

  final List<Note> _selectedNotes = [];
  List<Note> get selectedNotes => _selectedNotes;

  final List<Note> _pinnedNotes = [];
  List<Note> get pinnedNotes => _pinnedNotes;

  void addNote(Note note) {
    _notes.add(note);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void updateNote(Note currentNote, Note newNote) {
    final index = _notes.indexOf(currentNote);
    if (index == -1) {
      if (_pinnedNotes.contains(currentNote)) {
        final pinnedIndex = _pinnedNotes.indexOf(currentNote);
        _pinnedNotes[pinnedIndex] = newNote;
      } else {
        addNote(newNote);
      }
    } else {
      _notes[index] = newNote;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void removeNote(Note note) {
    if (_pinnedNotes.contains(note)) {
      deletePinnedNote(note);
    } else {
      _notes.remove(note);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void toggleSelectedNote(Note note) {
    if (_selectedNotes.contains(note)) {
      removeSelectedNote(note);
    } else {
      addSelectedNote(note);
    }
  }

  void addSelectedNote(Note note) {
    _selectedNotes.add(note);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void removeSelectedNote(Note note) {
    _selectedNotes.remove(note);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void clearSelectedNotes() {
    _selectedNotes.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void addPinnedNote(Note note) {
    if (_pinnedNotes.length < _pinLimit) {
      _pinnedNotes.insert(0, note);
      _notes.remove(note);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void deletePinnedNote(Note note) {
    _pinnedNotes.remove(note);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void removePinnedNote(Note note) {
    _pinnedNotes.remove(note);
    _notes.add(note);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}
