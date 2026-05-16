import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../listing/models/map_suggestions_response_model.dart';
import '../../../listing/repositories/listing_repository_interface.dart';

// class LocationSuggesterTextFieldWidget extends StatelessWidget {
//
//   final TextEditingController controller;
//   final RxList<PlaceSuggestion> suggestions = RxList<PlaceSuggestion>();
//   final Future<void> Function(PlaceSuggestion)? onSuggestionSelected;
//   final String? hintText;
//   final Widget? prefixIcon;
//   final EdgeInsetsGeometry? contentPadding;
//   final bool? isDense, isCollapsed;
//
//   LocationSuggesterTextFieldWidget({
//     super.key,
//     required this.controller,
//     this.onSuggestionSelected,
//     this.hintText,
//     this.prefixIcon,
//     this.contentPadding,
//     this.isCollapsed,
//     this.isDense
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     InputBorder inputBorder = OutlineInputBorder(
//       borderRadius: BorderRadius.circular(8),
//       borderSide: BorderSide(
//         width: 1,
//         color: Colors.grey.withOpacity(0.5),
//       ),
//     );
//     TextStyle textStyle = const TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.w400,
//     );
//     return TypeAheadField<PlaceSuggestion>(
//       controller: controller,
//       builder: (context, textController, focusNode) => TextField(
//         controller: textController,
//         focusNode: focusNode,
//         autofocus: false,
//         style: textStyle.copyWith(color: const Color(0xff1f2427)),
//         decoration: InputDecoration(
//           hintText: hintText ?? 'Search...',
//           isDense: isDense ?? true,
//           isCollapsed: isCollapsed ?? true,
//           filled: true,
//           prefixIcon: prefixIcon,
//           fillColor: Colors.white,
//           contentPadding: contentPadding ?? const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
//           border: inputBorder,
//           enabledBorder: inputBorder,
//           errorBorder: inputBorder,
//           focusedBorder: inputBorder,
//         ),
//       ),
//       decorationBuilder: (context, child) => Material(
//         type: MaterialType.card,
//         elevation: 4,
//         borderRadius: BorderRadius.circular(6),
//         child: child,
//       ),
//       itemBuilder: (context, suggestion) => Padding(
//         padding: const EdgeInsets.symmetric(
//             horizontal: 12.0, vertical: 6),
//         child: Row(
//           children: [
//             const Icon(Icons.location_on_outlined),
//             const Gap(6),
//             Expanded(child: Text(suggestion.address ?? '')),
//           ],
//         ),
//       ),
//       onSelected: onSuggestionSelected,
//       suggestionsCallback: suggestionsCallback,
//       itemSeparatorBuilder: itemSeparatorBuilder,
//       listBuilder: gridLayoutBuilder,
//     );
//   }
//
//   Future<List<PlaceSuggestion>> suggestionsCallback(String query) async {
//     if (query.isEmpty) {
//       return [];
//     }
//
//     // try {
//     final response = await Get.find<ListingRepositoryInterface>().getMapSuggestions(place: query);
//
//     // listings.value = response.data;
//
//     suggestions.value = response.data is List ? response.data ?? [] : [];
//
//     return suggestions.toList();
//   }
//
//   Widget itemSeparatorBuilder(BuildContext context, int index) => const Gap(2);
//
//   Widget gridLayoutBuilder(BuildContext context, List<Widget> items) {
//     return ListView(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       shrinkWrap: true,
//       children: items,
//     );
//   }
// }
class LocationSuggesterTextFieldWidget extends StatefulWidget {
  final TextEditingController controller;
  final Future<void> Function(PlaceSuggestion)? onSuggestionSelected;
  final String? hintText;
  final Widget? prefixIcon;
  final EdgeInsetsGeometry? contentPadding;
  final bool? isDense, isCollapsed;

  const LocationSuggesterTextFieldWidget({
    super.key,
    required this.controller,
    this.onSuggestionSelected,
    this.hintText,
    this.prefixIcon,
    this.contentPadding,
    this.isCollapsed,
    this.isDense,
  });

  @override
  State<LocationSuggesterTextFieldWidget> createState() =>
      _LocationSuggesterTextFieldWidgetState();
}

class _LocationSuggesterTextFieldWidgetState
    extends State<LocationSuggesterTextFieldWidget> {
  final RxList<PlaceSuggestion> suggestions = RxList<PlaceSuggestion>();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Hide dropdown when focus lost (tap outside)
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        FocusScope.of(context).unfocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    InputBorder inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        width: 1,
        color: Colors.grey.withOpacity(0.5),
      ),
    );

    TextStyle textStyle = const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
    );

    return TypeAheadField<PlaceSuggestion>(
      controller: widget.controller,
      hideWithKeyboard: true, // ✅ Hide when keyboard closes
      hideOnEmpty: true,
      hideOnUnfocus: true, // ✅ Hide when focus lost
      retainOnLoading: true,
      focusNode: _focusNode,
      // Removed `keepSuggestionsOnSuggestionSelected` (deprecated)
      builder: (context, textController, focusNode) => TextField(
        controller: textController,
        focusNode: focusNode,
        autofocus: false,
        style: textStyle.copyWith(color: const Color(0xff1f2427)),
        decoration: InputDecoration(
          hintText: widget.hintText ?? 'Search...',
          isDense: widget.isDense ?? true,
          isCollapsed: widget.isCollapsed ?? true,
          filled: true,
          prefixIcon: widget.prefixIcon,
          fillColor: Colors.white,
          contentPadding: widget.contentPadding ??
              const EdgeInsets.symmetric(vertical: 11, horizontal: 15),
          border: inputBorder,
          enabledBorder: inputBorder,
          errorBorder: inputBorder,
          focusedBorder: inputBorder,
        ),
      ),
      decorationBuilder: (context, child) => Material(
        type: MaterialType.card,
        elevation: 4,
        borderRadius: BorderRadius.circular(6),
        child: child,
      ),
      itemBuilder: (context, suggestion) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6),
        child: Row(
          children: [
            const Icon(Icons.location_on_outlined),
            const SizedBox(width: 6),
            Expanded(child: Text(suggestion.address ?? '')),
          ],
        ),
      ),
      onSelected: widget.onSuggestionSelected,
      suggestionsCallback: suggestionsCallback,
      itemSeparatorBuilder: itemSeparatorBuilder,
      listBuilder: gridLayoutBuilder,
    );
  }

  Future<List<PlaceSuggestion>> suggestionsCallback(String query) async {
    if (query.isEmpty) {
      return [];
    }

    final response =
    await Get.find<ListingRepositoryInterface>().getMapSuggestions(place: query);

    suggestions.value = response.data is List ? response.data ?? [] : [];
    return suggestions.toList();
  }

  Widget itemSeparatorBuilder(BuildContext context, int index) =>
      const SizedBox(height: 2);

  /// ✅ Scroll works, doesn’t hide when dragging
  Widget gridLayoutBuilder(BuildContext context, List<Widget> items) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 250),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          // prevent suggestion box from closing while scrolling
          return true;
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shrinkWrap: true,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: items.length,
          itemBuilder: (context, index) => items[index],
        ),
      ),
    );
  }
}



// Hello I am Tamim