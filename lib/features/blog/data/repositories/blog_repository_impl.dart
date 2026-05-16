import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/blog/data/models/guest_blog_model.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import 'blog_repository_interface.dart';

class BlogRepositoryImpl implements BlogRepositoryInterface {
  final ApiClient _apiClient = Get.find<ApiClient>();

  @override
  Future<GuestBlogModel> getBlogs({
    required int page,
    required int pageSize,
  }) async {
    try {
      final response = await _apiClient.get(
        '/blogs/public/blogs/',
        queryParameters: {
          'page': page,
          'page_size': pageSize,
        },
      );
      return GuestBlogModel.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

// Hello I am Tamim