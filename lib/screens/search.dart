import 'package:notesy/res/res.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  late final List<Note> _searchNotes;

  @override
  void initState() {
    super.initState();
    _searchNotes = context.read<NotesProvider>().pinnedNotes
      ..addAll(context.read<NotesProvider>().notes);
    _searchController.addListener(() {
      setState(() {
        _searchNotes.clear();
        _searchNotes.addAll(context.read<NotesProvider>().pinnedNotes
          ..addAll(context.read<NotesProvider>().notes));
        _searchNotes.removeWhere((note) {
          return !note.title.toLowerCase().contains(_searchController.text.toLowerCase()) &&
              !note.content.toLowerCase().contains(_searchController.text.toLowerCase());
        });
      });
    });
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
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ],
      ),
    );
  }
}
