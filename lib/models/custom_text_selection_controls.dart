import 'package:notesy/res/res.dart';

class CustomTextSelectionControls extends MaterialTextSelectionControls {
  @override
  Widget buildToolbar(
    BuildContext context,
    Rect globalEditableRegion,
    double textLineHeight,
    Offset position,
    List<TextSelectionPoint> endpoints,
    TextSelectionDelegate delegate,
    ValueListenable<ClipboardStatus>? clipboardStatus,
    Offset? lastSecondaryTapDownPosition,
  ) {
    final toolbarX = globalEditableRegion.left + position.dx - 50;
    final toolbarY =
        globalEditableRegion.top + position.dy - textLineHeight - 56;

    return Stack(
      children: [
        Positioned(
          left: toolbarX.clamp(8.0, MediaQuery.of(context).size.width - 200.0),
          top: toolbarY.clamp(8.0, MediaQuery.of(context).size.height - 48.0),
          child: Material(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.r)),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).popupMenuTheme.color,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children:
                    _buildToolbarButtons(context, delegate, clipboardStatus),
              ),
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildToolbarButtons(
      BuildContext context,
      TextSelectionDelegate delegate,
      ValueListenable<ClipboardStatus>? clipboardStatus) {
    final List<Widget> buttons = [];

    if (canCut(delegate)) {
      buttons.add(
        TextButton(
          onPressed: () {
            handleCut(delegate);
            delegate.hideToolbar();
          },
          child: Text(
            'Cut',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
          ),
        ),
      );
    }

    if (canCopy(delegate)) {
      buttons.add(
        TextButton(
          onPressed: () {
            handleCopy(delegate);
            delegate.hideToolbar();
          },
          child: Text(
            'Copy',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
          ),
        ),
      );
    }

    if (clipboardStatus != null &&
        clipboardStatus.value == ClipboardStatus.pasteable) {
      buttons.add(
        TextButton(
          onPressed: () {
            handlePaste(delegate);
            delegate.hideToolbar();
          },
          child: Text(
            'Paste',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
          ),
        ),
      );
    }

    if (canSelectAll(delegate)) {
      buttons.add(
        TextButton(
          onPressed: () {
            handleSelectAll(delegate);
          },
          child: Text(
            'Select all',
            style:
                TextStyle(color: Theme.of(context).textTheme.bodySmall!.color),
          ),
        ),
      );
    }

    return buttons;
  }

  @override
  bool canCut(TextSelectionDelegate delegate) {
    final textSelection = delegate.textEditingValue.selection;
    return !textSelection.isCollapsed && textSelection.isValid;
  }

  @override
  bool canCopy(TextSelectionDelegate delegate) {
    final textSelection = delegate.textEditingValue.selection;
    return !textSelection.isCollapsed && textSelection.isValid;
  }

  @override
  bool canPaste(TextSelectionDelegate delegate) {
    return delegate.textEditingValue.selection.isValid;
  }

  @override
  bool canSelectAll(TextSelectionDelegate delegate) {
    final textValue = delegate.textEditingValue.text;
    final selection = delegate.textEditingValue.selection;
    return textValue.isNotEmpty &&
        (selection.baseOffset != 0 ||
            selection.extentOffset != textValue.length);
  }

  @override
  void handleCut(TextSelectionDelegate delegate) {
    final String text = delegate.textEditingValue.selection
        .textInside(delegate.textEditingValue.text);
    Clipboard.setData(ClipboardData(text: text));
    final newText = delegate.textEditingValue.text.replaceRange(
      delegate.textEditingValue.selection.start,
      delegate.textEditingValue.selection.end,
      '',
    );
    delegate.userUpdateTextEditingValue(
      TextEditingValue(
        text: newText,
        selection: TextSelection.collapsed(
            offset: delegate.textEditingValue.selection.start),
      ),
      SelectionChangedCause.toolbar,
    );
  }

  @override
  void handleCopy(TextSelectionDelegate delegate) {
    final String text = delegate.textEditingValue.selection
        .textInside(delegate.textEditingValue.text);
    Clipboard.setData(ClipboardData(text: text));

    final newSelectionOffset = delegate.textEditingValue.selection.end;
    delegate.userUpdateTextEditingValue(
      delegate.textEditingValue.copyWith(
        selection: TextSelection.collapsed(offset: newSelectionOffset),
      ),
      SelectionChangedCause.toolbar,
    );
  }

  @override
  Future<void> handlePaste(TextSelectionDelegate delegate) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (data != null) {
      final TextEditingValue value = delegate.textEditingValue;
      final String newText = value.text.replaceRange(
        value.selection.start,
        value.selection.end,
        data.text ?? '',
      );
      delegate.userUpdateTextEditingValue(
        TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(
            offset: value.selection.start + (data.text?.length ?? 0),
          ),
        ),
        SelectionChangedCause.toolbar,
      );
    }
  }

  @override
  void handleSelectAll(TextSelectionDelegate delegate) {
    final textValue = delegate.textEditingValue.text;
    delegate.userUpdateTextEditingValue(
      delegate.textEditingValue.copyWith(
        selection: TextSelection(baseOffset: 0, extentOffset: textValue.length),
      ),
      SelectionChangedCause.toolbar,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      delegate.bringIntoView(delegate.textEditingValue.selection.base);
    });
  }
}
