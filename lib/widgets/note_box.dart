import 'package:notesy/res/res.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.elevation = 0,
  });

  final Note note;
  final double elevation;

  String get title =>
      note.title.isEmpty ? note.content.split('\n').first.trim() : note.title;

  String? get content {
    if (note.title.isNotEmpty) {
      return note.content.trim().isEmpty ? null : note.content.trim();
    }
    return note.content.split('\n').skip(1).join('\n').trim().isEmpty
        ? null
        : note.content.split('\n').skip(1).join('\n').trim();
  }

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        if (context.read<NotesProvider>().selectedNotes.isEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteScreen(note),
            ),
          );
        } else {
          context.read<NotesProvider>().toggleSelectedNote(note);
        }
      },
      onLongTap: () {
        context.read<NotesProvider>().toggleSelectedNote(note);
      },
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: context.watch<NotesProvider>().selectedNotes.contains(note)
            ? Theme.of(context).canvasColor
            : null,
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      content ?? 'No text',
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            fontSize: 12.sp,
                            color: Theme.of(context)
                                .textTheme
                                .bodySmall!
                                .color!
                                .withOpacity(0.7),
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    4.sH,
                    Row(
                      children: [
                        Text(
                          note.dateToString(),
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                                fontSize: 10.sp,
                                color: Theme.of(context).hintColor,
                              ),
                        ),
                        4.sW,
                        if (note.isPinned)
                          Icon(
                            Icons.push_pin_outlined,
                            size: 12.sp,
                            color: Theme.of(context).hintColor,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              if (context.watch<NotesProvider>().selectedNotes.isNotEmpty)
                Checkbox(
                  value: context
                      .watch<NotesProvider>()
                      .selectedNotes
                      .contains(note),
                  onChanged: (value) {
                    context.read<NotesProvider>().toggleSelectedNote(note);
                  },
                  side: BorderSide.none,
                  activeColor: Colors.transparent,
                  checkColor: Theme.of(context).primaryColor,
                  fillColor: MaterialStateProperty.resolveWith(
                    (states) {
                      if (states.contains(MaterialState.selected)) {
                        return Colors.transparent;
                      }
                      return Colors.grey.withOpacity(0.5);
                    },
                  ),
                  shape: const CircleBorder(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
