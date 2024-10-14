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
        leading: context.watch<NotesProvider>().selectedNotes.isNotEmpty
            ? CloseButton(
                onPressed: () {
                  context.read<NotesProvider>().clearSelected();
                },
              )
            : null,
        actions: [
          context.watch<NotesProvider>().selectedNotes.isEmpty
              ? IconButton(
                  icon: const Icon(
                    IconlyLight.setting,
                  ),
                  onPressed: () {},
                )
              : IconButton(
                  icon: const Icon(
                    Icons.checklist_rtl_rounded,
                  ),
                  onPressed: () {
                    if (context.read<NotesProvider>().selectedNotes.length ==
                        context.read<NotesProvider>().notes.length) {
                      context.read<NotesProvider>().clearSelected();
                    } else {
                      for (final note in context.read<NotesProvider>().notes) {
                        if (!context
                            .read<NotesProvider>()
                            .selectedNotes
                            .contains(note)) {
                          context.read<NotesProvider>().addSelected(note);
                        }
                      }
                    }
                  },
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
      bottomNavigationBar: context.watch<NotesProvider>().selectedNotes.isEmpty
          ? null
          : BottomSheet(
              constraints: BoxConstraints(
                maxHeight: 48.h,
              ),
              onClosing: () {},
              builder: (context) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        IconlyLight.lock,
                        color: Theme.of(context).dividerColor,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(
                        IconlyLight.delete,
                        color: Theme.of(context).dividerColor,
                      ),
                      onPressed: () {},
                    ),
                  ],
                );
              },
            ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: context.watch<NotesProvider>().selectedNotes.isEmpty
                  ? 0
                  : 16.h,
            ),
            Row(
              children: [
                Text(
                  context.watch<NotesProvider>().selectedNotes.isEmpty
                      ? 'Notesy'
                      : '${context.watch<NotesProvider>().selectedNotes.length} item selected',
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
                if (context.read<NotesProvider>().selectedNotes.isEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                }
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
