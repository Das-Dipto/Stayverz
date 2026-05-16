import 'package:get/get.dart';

import 'package:stayverz_flutter_app/core/constants/app_routes.dart';
import 'package:stayverz_flutter_app/features/blog/data/models/guest_blog_model.dart';
import '../data/repositories/blog_repository_interface.dart';

class BlogController extends GetxController {
  final BlogRepositoryInterface _repository;

  // Reactive variables
  final RxList<DataItem> blogs = <DataItem>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxInt totalPages = 1.obs;
  final int pageSize = 10;
  final RxBool hasMore = true.obs;

  BlogController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchBlogs();
  }

  Future<void> fetchBlogs({bool loadMore = false}) async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;

      if (!loadMore) {
        currentPage.value = 1;
        blogs.clear();
      } else {
        if (!hasMore.value) return;
        currentPage.value++;
      }

      final response = await _repository.getBlogs(
        page: currentPage.value,
        pageSize: pageSize,
      );

      blogs.addAll(response.data);

      // Update pagination info
      totalPages.value = (response.metaData.total / pageSize).ceil();
      hasMore.value = currentPage.value < totalPages.value;
    } catch (e) {
      errorMessage.value = 'Failed to load blogs. Please try again.';
      // If loading more fails, decrement the page counter
      if (loadMore) {
        currentPage.value--;
      }
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshBlogs() async {
    await fetchBlogs(loadMore: false);
  }

  void onBlogTap(DataItem blog) {
    // Navigate to blog details using the route helper
    AppRoute.toBlogDetails(blog);
  }
}

// Hello I am Tamim