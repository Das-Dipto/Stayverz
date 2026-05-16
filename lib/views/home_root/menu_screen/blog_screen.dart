import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../features/blog/controllers/blog_controller.dart';
import '../../../features/blog/data/models/guest_blog_model.dart';
import '../../../widgets/own_app_bar.dart';

class BlogScreen extends StatefulWidget {
  const BlogScreen({super.key});

  @override
  State<BlogScreen> createState() => _BlogScreenState();
}

class _BlogScreenState extends State<BlogScreen> {
  final BlogController _controller = Get.put(BlogController(Get.find()));
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _controller.fetchBlogs();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_controller.isLoading.value &&
        _controller.hasMore.value) {
      _controller.fetchBlogs(loadMore: true);
    }
  }

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
                color: Colors.grey.withOpacity(0.1),
              ),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios, size: 20),
                color: Colors.black,
              ),
            ),
            const Text(
              'Blogs',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 35), // For centering the title
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _controller.refreshBlogs,
        child: Obx(() {
          if (_controller.isLoading.value && _controller.blogs.isEmpty) {
            return _buildShimmerEffect();
          }

          if (_controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_controller.errorMessage.value),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _controller.refreshBlogs,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (_controller.blogs.isEmpty) {
            return const Center(child: Text('No blogs available'));
          }

          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount:
                _controller.blogs.length + (_controller.hasMore.value ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= _controller.blogs.length) {
                return _buildLoader();
              }
              return _buildBlogItem(_controller.blogs[index]);
            },
          );
        }),
      ),
    );
  }

  Widget _buildBlogItem(DataItem blog) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _controller.onBlogTap(blog),
        borderRadius: BorderRadius.circular(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 110,
              width: 105,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8)
              ),
              child: CachedNetworkImage(
                imageUrl: blog.image,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    Container(height: 180, color: Colors.grey[200]),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
            Gap(10),
            // if (blog.image != null && blog.image.isNotEmpty)
            //   ClipRRect(
            //     borderRadius: const BorderRadius.vertical(
            //       top: Radius.circular(12),
            //     ),
            //     child: CachedNetworkImage(
            //       imageUrl: blog.image,
            //       height: 180,
            //       width: double.infinity,
            //       fit: BoxFit.cover,
            //       placeholder: (context, url) =>
            //           Container(height: 180, color: Colors.grey[200]),
            //       errorWidget: (context, url, error) => Container(
            //         height: 180,
            //         color: Colors.grey[200],
            //         child: const Icon(Icons.error),
            //       ),
            //     ),
            //   )
            // else
            //   Container(
            //     height: 180,
            //     width: double.infinity,
            //     decoration: BoxDecoration(
            //       color: Colors.grey[200],
            //       borderRadius: const BorderRadius.vertical(
            //         top: Radius.circular(12),
            //       ),
            //     ),
            //     child: const Icon(Icons.image_not_supported, size: 50),
            //   ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDate(blog.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${_getMonthName(date.month)} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  String _getMonthName(int month) {
    const monthNames = [
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
    return monthNames[month - 1];
  }

  Widget _buildLoader() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: 280,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
    );
  }
}

// Hello I am Tamim