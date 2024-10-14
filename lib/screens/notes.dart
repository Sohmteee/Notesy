import 'package:notesy/res/res.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 32.h,
        actions: [
          const Icon(
            IconlyLight.setting,
          ),
          16.sW,
        ],
      ),
      floatingActionButton: context.watch<NotesProvider>().selectedNotes.isEmpty
          ? FloatingActionButton(
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NoteScreen(
                      Note(),
                    ),
                  ),
                );
              },
              child: const Icon(
                Icons.add,
              ),
            )
          : null,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  context.watch<NotesProvider>().selectedNotes.isEmpty
                      ? 'Notesy'
                      : '${context.watch<NotesProvider>().selectedNotes.length} selected',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            16.sH,
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(),
                  ),
                );
              },
              child: const Hero(
                tag: 'search',
                child: Material(
                  color: Colors.transparent,
                  child: AppSearchBar(
                    editable: false,
                  ),
                ),
              ),
            ),
            8.sH,
            Expanded(
              child: ListView.builder(
                itemCount: context.watch<NotesProvider>().notes.length,
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(vertical: 8.h),
                itemBuilder: (context, index) {
                  return NoteCard(
                    elevation: 0,
                    note: context.watch<NotesProvider>().notes[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
