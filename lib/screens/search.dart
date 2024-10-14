import 'package:notesy/res/res.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _searchNotes

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
