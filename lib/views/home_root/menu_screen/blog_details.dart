import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../features/blog/data/models/guest_blog_model.dart';
import '../../../widgets/own_app_bar.dart';

class BlogDetails extends StatefulWidget {
  final DataItem? blog;

  const BlogDetails({super.key, required this.blog});

  @override
  State<BlogDetails> createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OwnAppBar(
        appHeight: 60,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
              ),
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(Icons.arrow_back, size: 20,),
                color: Colors.black,
              ),
            ),
            Text(
              'Blog',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 1.50,
              ),
            ),
            Gap(40),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          Gap(16),
          Text(
            widget.blog?.title ?? 'No Title',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              fontSize: 24,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          Gap(10),
          Text(
            widget.blog?.createdAt != null
                ? (() {
                  final date = DateTime.tryParse(widget.blog!.createdAt);
                  if (date == null) return '';
                  final months = [
                    '',
                    'Jan',
                    'Feb',
                    'Mar',
                    'Apr',
                    'May',
                    'Jun',
                    'Jul',
                    'Aug',
                    'Sep',
                    'Oct',
                    'Nov',
                    'Dec',
                  ];
                  return '${date.day} ${months[date.month]} ${date.year}';
                })()
                : '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
          Gap(5),
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child:
                widget.blog?.image != null && widget.blog!.image.isNotEmpty
                    ? CachedNetworkImage(
                      imageUrl: widget.blog!.image,
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: const Icon(
                              Icons.error_outline,
                              color: Colors.grey,
                            ),
                          ),
                    )
                    : Container(
                      height: 300,
                      color: Colors.grey[200],
                      child: const Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey,
                        ),
                      ),
                    ),
          ),
          Gap(20),
          if (widget.blog != null && widget.blog!.description.isNotEmpty) ...[
            // Text(
            //   'Description',
            //   style: TextStyle(
            //     color: Colors.black,
            //     fontSize: 20,
            //     fontFamily: 'Inter',
            //     fontWeight: FontWeight.w600,
            //     height: 1.33,
            //   ),
            // ),
            // Gap(10),
            // Divider(color: Color(0xFFA9A9B0)),
            // Gap(10),
            Html(
              data: widget.blog!.description,
              style: {
                "body": Style(
                  color: Colors.black87,
                  fontSize: FontSize(16),
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                  lineHeight: LineHeight.number(1.2),
                ),
                'br': Style(lineHeight: LineHeight.number(-2)),
                "a": Style(
                  color: Colors.blue,
                  textDecoration: TextDecoration.underline,
                ),
              },
              onLinkTap: (url, data, element) async {
                if (url != null) {
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                }
              },

              // onAnchorTap handler removed due to persistent lint issues. The default flutter_html behavior will open links in the browser.
            ),
            Gap(20),
          ],

          Gap(20),
        ],
      ),
    );
  }
}

// Hello I am Tamim