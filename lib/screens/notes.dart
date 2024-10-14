import 'package:notesy/res/res.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (context.read<NotesProvider>().selectedNotes.isNotEmpty) {
          setState(() {
            context.read<NotesProvider>().clearSelectedNotes();
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        floatingActionButton:
            context.watch<NotesProvider>().selectedNotes.isEmpty
                ? buildFAB(context)
                : null,
        bottomNavigationBar:
            context.watch<NotesProvider>().selectedNotes.isEmpty
                ? null
                : buildBottomSheet(context),
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
                child: context.watch<NotesProvider>().notes.isEmpty &&
                        context.watch<NotesProvider>().pinnedNotes.isEmpty
                    ? Center(
                        child: Text(
                          'No notes yet',
                          style: TextStyle(
                            color: Colors.grey.withOpacity(.5),
                          ),
                        ),
                      )
                    : ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        children: [
                          ...context.watch<NotesProvider>().pinnedNotes.map(
                                (note) => NoteCard(
                                  note: note,
                                ),
                              ),
                          ...context.watch<NotesProvider>().notes.map(
                                (note) => NoteCard(
                                  note: note,
                                ),
                              ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 32.h,
      leading: context.watch<NotesProvider>().selectedNotes.isNotEmpty
          ? CloseButton(
              onPressed: () {
                context.read<NotesProvider>().clearSelectedNotes();
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
                icon: Icon(
                  Icons.checklist_rtl_rounded,
                  color: (context.read<NotesProvider>().selectedNotes.length ==
                          context.read<NotesProvider>().notes.length)
                      ? Theme.of(context).primaryColor
                      : null,
                ),
                onPressed: () {
                  if (context.read<NotesProvider>().selectedNotes.length ==
                      context.read<NotesProvider>().notes.length) {
                    context.read<NotesProvider>().clearSelectedNotes();
                  } else {
                    for (final note in context.read<NotesProvider>().notes) {
                      if (!context
                          .read<NotesProvider>()
                          .selectedNotes
                          .contains(note)) {
                        context.read<NotesProvider>().addSelectedNote(note);
                      }
                    }
                  }
                },
              ),
        16.sW,
      ],
    );
  }

  FloatingActionButton buildFAB(BuildContext context) {
    return FloatingActionButton(
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
    );
  }

  BottomSheet buildBottomSheet(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      builder: (context) {
        final color =
            Theme.of(context).textTheme.bodyMedium!.color!.withOpacity(0.7);
        return Container(
          height: 64.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZoomTapAnimation(
                    onTap: () {},
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Icon(
                            IconlyLight.lock,
                            size: 20.sp,
                            color: color,
                          ),
                          6.sH,
                          Text(
                            'Hide',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (context
                      .watch<NotesProvider>()
                      .selectedNotes
                      .where((selectedNote) => !context
                          .read<NotesProvider>()
                          .pinnedNotes
                          .contains(selectedNote))
                      .length <=
                  context.watch<NotesProvider>().pinLimit -
                      context.watch<NotesProvider>().pinnedNotes.length)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ZoomTapAnimation(
                      onTap: context.watch<NotesProvider>().selectedNotes.every(
                              (note) => context
                                  .watch<NotesProvider>()
                                  .pinnedNotes
                                  .contains(note))
                          ? () {
                              for (final note in context
                                  .read<NotesProvider>()
                                  .selectedNotes) {
                                context
                                    .read<NotesProvider>()
                                    .removePinnedNote(note);
                              }
                              context
                                  .read<NotesProvider>()
                                  .clearSelectedNotes();
                            }
                          : (context
                                      .watch<NotesProvider>()
                                      .selectedNotes
                                      .where((selectedNote) => !context
                                          .read<NotesProvider>()
                                          .pinnedNotes
                                          .contains(selectedNote))
                                      .length >
                                  context.watch<NotesProvider>().pinLimit -
                                      context
                                          .watch<NotesProvider>()
                                          .pinnedNotes
                                          .length)
                              ? null
                              : () {
                                  for (final note in context
                                      .read<NotesProvider>()
                                      .selectedNotes) {
                                    if (!context
                                        .read<NotesProvider>()
                                        .pinnedNotes
                                        .contains(note)) {
                                      context
                                          .read<NotesProvider>()
                                          .addPinnedNote(note);
                                    }
                                  }
                                  context
                                      .read<NotesProvider>()
                                      .clearSelectedNotes();
                                },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            Transform.rotate(
                              angle: 45 * (3.1415926535897932 / 180),
                              child: Icon(
                                Icons.push_pin_outlined,
                                size: 20.sp,
                                color: color,
                              ),
                            ),
                            6.sH,
                            Text(
                              context
                                      .watch<NotesProvider>()
                                      .selectedNotes
                                      .every((note) => context
                                          .watch<NotesProvider>()
                                          .pinnedNotes
                                          .contains(note))
                                  ? 'Unpin'
                                  : 'Pin',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: color,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ZoomTapAnimation(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: Theme.of(context).cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(12.r),
                          ),
                        ),
                        builder: (context) {
                          return Padding(
                            padding: EdgeInsets.all(16.sp),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Delete ${context.read<NotesProvider>().selectedNotes.length} note${context.read<NotesProvider>().selectedNotes.length > 1 ? 's' : ''}?',
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                16.sH,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .color,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        for (final note in context
                                            .read<NotesProvider>()
                                            .selectedNotes) {
                                          context
                                              .read<NotesProvider>()
                                              .removeNote(note);
                                        }
                                        context
                                            .read<NotesProvider>()
                                            .clearSelectedNotes();
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        children: [
                          Icon(
                            IconlyLight.delete,
                            size: 20.sp,
                            color: color,
                          ),
                          6.sH,
                          Text(
                            'Delete',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
