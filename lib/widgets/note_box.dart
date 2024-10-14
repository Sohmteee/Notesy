import 'package:notesy/res/res.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({
    super.key,
    required this.note,
    this.elevation,
  });

  final Note note;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return ZoomTapAnimation(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NoteScreen(note),
          ),
        );
      },
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note.title ?? note.content.split('\n').first.trim(),
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                note.content,
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
              Text(
                note.dateToString(),
                style: Theme.of(context).textTheme.bodySmall!.copyWith(
                      fontSize: 10.sp,
                      color: Theme.of(context).hintColor,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
