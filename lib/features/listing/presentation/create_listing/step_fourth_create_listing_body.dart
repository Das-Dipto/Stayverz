import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';
import 'dart:async';

class StepFourthCreateListingBody extends StatefulWidget {
  StepFourthCreateListingBody({super.key});

  @override
  State<StepFourthCreateListingBody> createState() =>
      _StepFourthCreateListingBodyState();
}

class _StepFourthCreateListingBodyState
    extends State<StepFourthCreateListingBody> {
  QuillController? _titleQuillController;
  QuillController? _descQuillController;
  late final FocusNode _titleFocusNode;
  late final FocusNode _descFocusNode;
  late final ScrollController _titleScrollController;
  late final ScrollController _descScrollController;
  late final ListingController _listingController;
  bool _initialized = false;

  // Typing indicators
  bool _isTitleTyping = false;
  bool _isDescTyping = false;
  Timer? _titleTimer;
  Timer? _descTimer;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode();
    _descFocusNode = FocusNode();
    _titleScrollController = ScrollController();
    _descScrollController = ScrollController();
    _listingController = Get.find<ListingController>();
  }

  void _initIfNeeded() {
    if (_initialized) return;
    _initialized = true;

    // Title
    final existingTitle = _listingController.titleController.text.trim();
    if (existingTitle.isNotEmpty) {
      final doc = Document()..insert(0, existingTitle);
      _titleQuillController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _titleQuillController = QuillController.basic();
    }
    _titleQuillController!.addListener(() {
  _listingController.titleController.text =
      _titleQuillController!.document.toPlainText().replaceAll('\n', '').trim();
  _onTitleChanged();
});

    // Description
    final existingDesc = _listingController.descriptionController.text.trim();
    if (existingDesc.isNotEmpty) {
      final doc = Document()..insert(0, existingDesc);
      _descQuillController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _descQuillController = QuillController.basic();
    }
    _descQuillController!.addListener(() {
  _listingController.descriptionController.text =
      _descQuillController!.document.toPlainText().trim();
  _onDescChanged();
});
  }

  void _onTitleChanged() {
    setState(() => _isTitleTyping = true);
    _titleTimer?.cancel();
    _titleTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _isTitleTyping = false);
    });
  }

  void _onDescChanged() {
    setState(() => _isDescTyping = true);
    _descTimer?.cancel();
    _descTimer = Timer(const Duration(milliseconds: 900), () {
      if (mounted) setState(() => _isDescTyping = false);
    });
  }

  @override
  void dispose() {
    _titleTimer?.cancel();
    _descTimer?.cancel();
    _titleQuillController?.dispose();
    _descQuillController?.dispose();
    _titleFocusNode.dispose();
    _descFocusNode.dispose();
    _titleScrollController.dispose();
    _descScrollController.dispose();
    super.dispose();
  }

  Widget _buildToolbar(QuillController controller) {
    return Container(
      height: 36,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE4E7EC), width: 1)),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(7),
          bottomRight: Radius.circular(7),
        ),
        color: Color(0xFFF9FAFB),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: QuillSimpleToolbar(
          controller: controller,
          config: QuillSimpleToolbarConfig(
            toolbarSize: 28,
            buttonOptions: QuillSimpleToolbarButtonOptions(
              base: QuillToolbarBaseButtonOptions(
                iconSize: 14,
                iconButtonFactor: 1.0,
              ),
            ),
            showBoldButton: true,
            showItalicButton: true,
            showUnderLineButton: true,
            showAlignmentButtons: true,
            showFontSize: false,
            showListBullets: true,
            showListNumbers: true,
            showStrikeThrough: false,
            showColorButton: false,
            showBackgroundColorButton: false,
            showHeaderStyle: false,
            showLink: false,
            showSearchButton: false,
            showSubscript: false,
            showSuperscript: false,
            showInlineCode: false,
            showCodeBlock: false,
            showQuote: false,
            showIndent: false,
            showRedo: false,
            showUndo: false,
            showDividers: true,
            showFontFamily: false,
            showSmallButton: false,
            showClearFormat: false,
            showClipboardCopy: false,
            showClipboardCut: false,
            showClipboardPaste: false,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator({
    required bool isTyping,
    required String text,
  }) {
    final isEmpty = text.trim().isEmpty;

    if (isTyping) {
      // Typing indicator
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Typing",
            style: TextStyle(
              color: Colors.orange,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 6),
          SizedBox(
            width: 14,
            height: 14,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            ),
          ),
        ],
      );
    } else if (!isEmpty) {
      // Saved
      return const Icon(Icons.check_circle, color: Colors.green, size: 20);
    } else {
      // Missing
      return const Icon(Icons.error_outline, color: Colors.redAccent, size: 20);
    }
  }

  @override
  Widget build(BuildContext context) {
    _initIfNeeded();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- Title ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Property Title',
                    style: TextStyle(
                      color: Color(0xFF1D1D1D),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(4),
                  const Text(
                    "Choose an appealing title that highlights your property's unique charm.",
                    style: TextStyle(
                      color: Color(0xFF33496C),
                      fontSize: 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),
            ListenableBuilder(
              listenable: _titleQuillController!,
              builder: (context, _) {
                final currentText = _titleQuillController!.document.toPlainText();
                return _buildStatusIndicator(
                  isTyping: _isTitleTyping,
                  text: currentText,
                );
              },
            ),
          ],
        ),
        const Gap(10),

        // Title Editor
        ListenableBuilder(
          listenable: _titleFocusNode,
          builder: (context, _) {
            final hasFocus = _titleFocusNode.hasFocus;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasFocus ? Theme.of(context).primaryColor : const Color(0xFFD0D5DD),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: QuillEditor(
                      controller: _titleQuillController!,
                      focusNode: _titleFocusNode,
                      scrollController: _titleScrollController,
                      config: QuillEditorConfig(
                        placeholder: 'Write your awesome title',
                        minHeight: 30,
                        maxHeight: 70,
                        expands: false,
                        autoFocus: false,
                        padding: EdgeInsets.zero,
                        customStyles: DefaultStyles(
                          placeHolder: DefaultTextBlockStyle(
                            const TextStyle(color: Color(0xFF98A2B3), fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w400),
                            HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null,
                          ),
                          paragraph: DefaultTextBlockStyle(
                            const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.5),
                            HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14, bottom: 6, left: 14),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ListenableBuilder(
                        listenable: _titleQuillController!,
                        builder: (context, _) {
                          final length = _titleQuillController!.document.toPlainText().replaceAll('\n', '').length;
                          return Text('$length / 200', style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 11, fontFamily: 'Inter'));
                        },
                      ),
                    ),
                  ),
                  if (hasFocus) _buildToolbar(_titleQuillController!),
                ],
              ),
            );
          },
        ),

        const Gap(24),

        // --- Description ---
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Color(0xFF1D1D1D),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(4),
                  const Text(
                    'Share what makes your place special.',
                    style: TextStyle(
                      color: Color(0xFF33496C),
                      fontSize: 13,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            const Gap(12),
            ListenableBuilder(
              listenable: _descQuillController!,
              builder: (context, _) {
                final currentText = _descQuillController!.document.toPlainText();
                return _buildStatusIndicator(
                  isTyping: _isDescTyping,
                  text: currentText,
                );
              },
            ),
          ],
        ),
        const Gap(10),

        // Description Editor
        ListenableBuilder(
          listenable: _descFocusNode,
          builder: (context, _) {
            final hasFocus = _descFocusNode.hasFocus;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasFocus ? Theme.of(context).primaryColor : const Color(0xFFD0D5DD),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    child: QuillEditor(
                      controller: _descQuillController!,
                      focusNode: _descFocusNode,
                      scrollController: _descScrollController,
                      config: QuillEditorConfig(
                        placeholder: 'Description',
                        minHeight: 120,
                        maxHeight: 200,
                        expands: false,
                        autoFocus: false,
                        padding: EdgeInsets.zero,
                        customStyles: DefaultStyles(
                          placeHolder: DefaultTextBlockStyle(
                            const TextStyle(color: Color(0xFF98A2B3), fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w400),
                            HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null,
                          ),
                          paragraph: DefaultTextBlockStyle(
                            const TextStyle(color: Colors.black, fontSize: 14, fontFamily: 'Inter', fontWeight: FontWeight.w400, height: 1.5),
                            HorizontalSpacing.zero, VerticalSpacing.zero, VerticalSpacing.zero, null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 14, bottom: 6, left: 14),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ListenableBuilder(
                        listenable: _descQuillController!,
                        builder: (context, _) {
                          final length = _descQuillController!.document.toPlainText().replaceAll('\n', '').length;
                          return Text('$length / 2000', style: const TextStyle(color: Color(0xFF98A2B3), fontSize: 11, fontFamily: 'Inter'));
                        },
                      ),
                    ),
                  ),
                  if (hasFocus) _buildToolbar(_descQuillController!),
                ],
              ),
            );
          },
        ),
        const Gap(40),
      ],
    );
  }
}