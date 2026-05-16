import 'package:stayverz_flutter_app/features/blog/data/models/guest_blog_model.dart';

abstract class BlogRepositoryInterface {
  Future<GuestBlogModel> getBlogs({
    required int page,
    required int pageSize,
  });
}

// Hello I am Tamim