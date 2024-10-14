import 'package:notesy/res/res.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  late List<Note> _searchNotes;

  @override
  void initState() {
    super.initState();
    final notesProvider = context.read<NotesProvider>();
    _searchNotes = [...notesProvider.pinnedNotes, ...notesProvider.notes];
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      final searchQuery = _searchController.text.toLowerCase();
      final notesProvider = context.read<NotesProvider>();
      _searchNotes = [...notesProvider.pinnedNotes, ...notesProvider.notes]
          .where((note) =>
              note.title.toLowerCase().contains(searchQuery) ||
              note.content.toLowerCase().contains(searchQuery))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64.h,
        leadingWidth: 30.w,
        title: Hero(
          tag: 'search',
          child: Material(
            color: Colors.transparent,
            child: AppSearchBar(
              controller: _searchController,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
       _searchNotes.isEmpty ? Center :   ListView.builder(
            padding: EdgeInsets.only(top: 16.h),
            itemCount: _searchNotes.length,
            itemBuilder: (context, index) {
              final note = _searchNotes[index];
              return NoteCard(note: note);
            },
          ),
          if (_searchController.text.trim().isEmpty)
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                color: Colors.black87,
              ),
            ),
        ],
      ),
    );
  }
}
