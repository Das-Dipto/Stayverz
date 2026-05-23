import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/listing/controllers/listing_controller.dart';

class StepEighthCreateListingBody extends StatefulWidget {
  const StepEighthCreateListingBody({super.key});

  @override
  State<StepEighthCreateListingBody> createState() =>
      _StepEighthCreateListingBodyState();
}

class _StepEighthCreateListingBodyState
    extends State<StepEighthCreateListingBody> {
  QuillController? _quillController;
  late final FocusNode _focusNode;
  late final ScrollController _scrollController;
  late final ListingController _listingController;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _scrollController = ScrollController();
    _listingController = Get.find<ListingController>();
  }

  void _initQuillIfNeeded() {
    if (_initialized) return;
    _initialized = true;

    final existingText = _listingController.titleController.text.trim();

    if (existingText.isNotEmpty) {
      final doc = Document()..insert(0, existingText);
      _quillController = QuillController(
        document: doc,
        selection: const TextSelection.collapsed(offset: 0),
      );
    } else {
      _quillController = QuillController.basic();
    }

    _quillController!.addListener(() {
      final plain = _quillController!.document.toPlainText();
      _listingController.titleController.text = plain;
    });
  }

  @override
  void dispose() {
    _quillController?.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget _buildToolbar() {
    return Container(
      height: 36,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Color(0xFFE4E7EC), width: 1),
        ),
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
          controller: _quillController!,
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

  @override
  Widget build(BuildContext context) {
    // Init here so context is available and it only runs once
    _initQuillIfNeeded();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Now let\'s give your house a title',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.33,
          ),
        ),
        const Gap(12),
        const Text(
          'Short tile works best. Have fun with it you can always change it later',
          style: TextStyle(
            color: Color(0xFF33496C),
            fontSize: 15,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
        const Gap(30),
        ListenableBuilder(
          listenable: _focusNode,
          builder: (context, _) {
            final hasFocus = _focusNode.hasFocus;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasFocus
                      ? Theme.of(context).primaryColor
                      : const Color(0xFFD0D5DD),
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    child: QuillEditor(
                      controller: _quillController!,
                      focusNode: _focusNode,
                      scrollController: _scrollController,
                      config: QuillEditorConfig(
                        placeholder: 'Write your awesome title',
                        minHeight: 100,
                        maxHeight: 160,
                        expands: false,
                        autoFocus: false,
                        padding: EdgeInsets.zero,
                        customStyles: DefaultStyles(
                          placeHolder: DefaultTextBlockStyle(
                            const TextStyle(
                              color: Color(0xFF98A2B3),
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                            HorizontalSpacing.zero,
                            VerticalSpacing.zero,
                            VerticalSpacing.zero,
                            null,
                          ),
                          paragraph: DefaultTextBlockStyle(
                            const TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                            HorizontalSpacing.zero,
                            VerticalSpacing.zero,
                            VerticalSpacing.zero,
                            null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        right: 14, bottom: 6, left: 14),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: ListenableBuilder(
                        listenable: _quillController!,
                        builder: (context, _) {
                          final length = _quillController!.document
                              .toPlainText()
                              .replaceAll('\n', '')
                              .length;
                          return Text(
                            '$length / 200',
                            style: const TextStyle(
                              color: Color(0xFF98A2B3),
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (hasFocus) _buildToolbar(),
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