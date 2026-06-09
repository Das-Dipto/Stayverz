import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class EditListingItem extends StatelessWidget {
  final String title, value;
  final Function()? onPress;
  const EditListingItem({super.key, required this.title, required this.value, this.onPress});

  Widget _buildFormattedText(String value) {
    // Check if HTML
    if (value.contains('<') && value.contains('>')) {
      return Html(
        data: value,
        style: {
          "body": Style(
            color: const Color(0xFF67666B),
            fontSize: FontSize(16),
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            margin: Margins.zero,
            padding: HtmlPaddings.zero,
          ),
        },
      );
    }

    // Check if Markdown
    if (value.contains('**') ||
        value.contains('##') ||
        value.contains('__') ||
        value.contains('- ') ||
        value.contains('* ')) {
      return MarkdownBody(
        data: value,
        styleSheet: MarkdownStyleSheet(
          p: const TextStyle(
            color: Color(0xFF67666B),
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
            height: 1.5,
          ),
        ),
      );
    }

    // Plain text fallback
    return Text(
      value,
      style: const TextStyle(
        color: Color(0xFF67666B),
        fontSize: 16,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 1.50,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w600,
            height: 1.50,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: _buildFormattedText(value),
            ),
            SizedBox(
              height: 30,
              child: TextButton(
                onPressed: onPress,
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                    decoration: TextDecoration.underline,
                    height: 1.50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}