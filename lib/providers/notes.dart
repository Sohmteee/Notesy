import 'package:notesy/res/res.dart';

class NotesProvider with ChangeNotifier {
  int _pinLimit = 10;
  int get pinLimit => _pinLimit;
  set pinLimit(int pinLimit) {
    _pinLimit = pinLimit;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  final List _notes = box.get('notes', defaultValue: []);
  List get notes {
    return _notes..sort((a, b) => b.date.compareTo(a.date));
  }

  final List _selectedNotes = [];
  List get selectedNotes => _selectedNotes;

  final List _pinnedNotes = box.get('pinnedNotes', defaultValue: []);
  List get pinnedNotes => _pinnedNotes;

  set selectedNotes(List selectedNotes) {
    _selectedNotes
      ..clear()
      ..addAll(selectedNotes);
    box.put('selectedNotes', _selectedNotes);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void addNote(Note note) {
    _notes.add(note);
    box.put('notes', _notes);
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
        box.put('pinnedNotes', _pinnedNotes);
      } else {
        addNote(newNote);
      }
    } else {
      _notes[index] = newNote;
      box.put('notes', _notes);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void deleteNote(Note note) {
    if (_pinnedNotes.contains(note)) {
      deletePinnedNote(note);
    } else {
      _notes.remove(note);
      box.put('notes', _notes);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void toggleSelectedNote(Note note) {
    if (_selectedNotes.contains(note)) {
      deleteSelectedNote(note);
    } else {
      addSelectedNote(note);
    }
  }

  void addSelectedNote(Note note) {
    _selectedNotes.add(note);
    box.put('selectedNotes', _selectedNotes);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void deleteSelectedNote(Note note) {
    _selectedNotes.remove(note);
    box.put('selectedNotes', _selectedNotes);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void clearSelectedNotes() {
    _selectedNotes.clear();
    box.put('selectedNotes', _selectedNotes);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void addPinnedNote(Note note) {
    if (_pinnedNotes.length < _pinLimit) {
      _pinnedNotes.insert(0, note);
      box.put('pinnedNotes', _pinnedNotes);
      _notes.remove(note);
      box.put('notes', _notes);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void deletePinnedNote(Note note) {
    _pinnedNotes.remove(note);
    box.put('pinnedNotes', _pinnedNotes);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void removePinnedNote(Note note) {
    _pinnedNotes.remove(note);
    box.put('pinnedNotes', _pinnedNotes);
    _notes.add(note);
    box.put('notes', _notes);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }


}
