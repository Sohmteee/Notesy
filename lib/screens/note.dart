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
  String noteTime = DateFormat('dd MMMM hh:mm a').format(DateTime.now());

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
          context.read<NotesProvider>().update(widget.note, note);
        } else {
          context.read<NotesProvider>().remove(widget.note);
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
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
                    break;
                }
              },
              itemBuilder: (context) {
                return [
                  PopupMenuItem(
                    value: 'share',
                    child: Row(
                      children: [
                        const Icon(Icons.share_outlined),
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
                        const Icon(IconlyLight.delete),
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
        ),
        body: Column(
          children: [
            TextField(
              focusNode: _titleFocusNode,
              controller: _titleController,
              style: TextStyle(
                fontSize: 16.sp,
              ),
              onTapOutside: (_) => _titleFocusNode.unfocus(),
              onChanged: (value) {
                setState(() {});
              },
              textCapitalization: TextCapitalization.sentences,
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
            4.sH,
            Row(
              children: [
                16.sW,
                Text(
                  noteTime,
                  style: TextStyle(
                    fontSize: 12.sp,
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
                    fontSize: 12.sp,
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
              child: TextField(
                focusNode: _contentFocusNode,
                controller: _contentController,
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
}
