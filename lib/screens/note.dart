import 'package:intl/intl.dart';
import 'package:notesy/models/custom_text_selection_controls.dart';
import 'package:notesy/res/res.dart';

class NoteScreen extends StatefulWidget {
  const NoteScreen(
    this.note, {
    super.key,
  });

  final Note note;

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  final _titleFocusNode = FocusNode(), _contentFocusNode = FocusNode();
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  bool canUndo = false, canRedo = false;

  final List<String> _undoStack = [];
  final List<String> _redoStack = [];
  static const int maxMoves = 10;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _contentController = TextEditingController(text: widget.note.content);

    _titleFocusNode.addListener(() {
      setState(() {});
    });
    _contentFocusNode.addListener(() {
      setState(() {});
    });

    _contentController.addListener(() {
      _handleUndoRedo();
    });
  }

  void _handleUndoRedo() {
    if (_undoStack.isEmpty || _undoStack.last != _contentController.text) {
      if (_undoStack.length == maxMoves) {
        _undoStack.removeAt(0);
      }
      _undoStack.add(_contentController.text);
      _redoStack.clear();
      setState(() {
        canUndo = _undoStack.length > 1;
        canRedo = _redoStack.isNotEmpty;
      });
    }
  }

  void _undo() {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(_undoStack.removeLast());
      _contentController.removeListener(_handleUndoRedo);
      _contentController.text = _undoStack.isEmpty ? '' : _undoStack.last;
      _contentController.addListener(_handleUndoRedo);
      setState(() {
        canUndo = _undoStack.length > 1;
        canRedo = _redoStack.isNotEmpty;
      });
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(_redoStack.removeLast());
      _contentController.removeListener(_handleUndoRedo);
      _contentController.text = _undoStack.last;
      _contentController.addListener(_handleUndoRedo);
      setState(() {
        canUndo = _undoStack.length > 1;
        canRedo = _redoStack.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _contentFocusNode.dispose();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  int get characterCount {
    return _contentController.text.replaceAll(' ', '').length;
  }

  @override
  Widget build(BuildContext context) {
    String noteTime = DateFormat('dd MMMM hh:mm a').format(widget.note.date);

    return WillPopScope(
      onWillPop: () async {
        if (_titleController.text.trim().isNotEmpty ||
            _contentController.text.trim().isNotEmpty) {
          final note = widget.note.copyWith(
            title: _titleController.text.trim(),
            content: _contentController.text.trim(),
            date: (_titleController.text.trim() == widget.note.title.trim() &&
                    _contentController.text.trim() == widget.note.content)
                ? null
                : DateTime.now(),
          );
          context.read<NotesProvider>().updateNote(widget.note, note);
        } else {
          context.read<NotesProvider>().removeNote(widget.note);
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        appBar: buildAppBar(context),
        body: Column(
          children: [
            TextField(
              focusNode: _titleFocusNode,
              controller: _titleController,
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              onTapOutside: (_) => _titleFocusNode.unfocus(),
              onChanged: (value) {
                setState(() {});
              },
              textCapitalization: TextCapitalization.sentences,
              cursorOpacityAnimates: true,
              selectionControls: CustomTextSelectionControls(),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                hintText: 'Title',
                hintStyle: TextStyle(
                  fontSize: 20.sp,
                  color: Theme.of(context).hintColor,
                ),
              ),
            ),
            Row(
              children: [
                16.sW,
                Text(
                  noteTime,
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .color!
                        .withOpacity(0.5),
                  ),
                ),
                SizedBox(
                  height: 16.h,
                  child: VerticalDivider(
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .color!
                        .withOpacity(0.5),
                    thickness: 1,
                  ),
                ),
                Text(
                  '$characterCount characters',
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .color!
                        .withOpacity(0.5),
                  ),
                ),
              ],
            ),
            Expanded(
              child: EditableText(
                focusNode: _contentFocusNode,
                controller: _contentController,
                cursorColor: Theme.of(context).textSelectionTheme!.cursorColor,
                style: TextStyle(
                  fontSize: 16.sp,
                ),
                onTapOutside: (_) => _contentFocusNode.unfocus(),
                onChanged: (value) {
                  setState(() {
                    _handleUndoRedo();
                  });
                },
                textCapitalization: TextCapitalization.sentences,
                maxLines: null,
                cursorOpacityAnimates: true,
                selectionControls: CustomTextSelectionControls(),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                  hintText: 'Start typing...',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: Theme.of(context).hintColor,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).cardColor,
      toolbarHeight: 48.h,
      actions: [
        IconButton(
          onPressed: canUndo ? _undo : null,
          splashColor: Colors.transparent,
          splashRadius: 1,
          icon: Icon(
            Icons.undo_rounded,
            color: canUndo ? null : Theme.of(context).hintColor,
          ),
        ),
        8.sW,
        IconButton(
          onPressed: canRedo ? _redo : null,
          splashColor: Colors.transparent,
          splashRadius: 1,
          icon: Icon(
            Icons.redo_rounded,
            color: canRedo ? null : Theme.of(context).hintColor,
          ),
        ),
        8.sW,
        PopupMenuButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          onSelected: (value) {
            switch (value) {
              case 'share':
                break;
              case 'delete':
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
                            'Delete this note?',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          16.sH,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                  Navigator.pop(context);
                                  context
                                      .read<NotesProvider>()
                                      .removeNote(widget.note);
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
                break;
            }
          },
          itemBuilder: (context) {
            return [
              PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(
                      Icons.share_outlined,
                      size: 20.sp,
                    ),
                    8.sW,
                    Text(
                      'Share',
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      IconlyLight.delete,
                      size: 20.sp,
                    ),
                    8.sW,
                    Text(
                      'Delete',
                      style: TextStyle(
                        fontSize: 16.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
        ),
        8.sW,
      ],
    );
  }
}
