import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/features/blog/data/models/guest_blog_model.dart';
import 'package:stayverz_flutter_app/views/home_root/host_bottom_navigation_bar_view.dart';
import 'package:stayverz_flutter_app/features/auth/views/login_view.dart';
import 'package:stayverz_flutter_app/views/home_root/guest_bottom_navigation_bar_view.dart';
import 'package:stayverz_flutter_app/views/home_root/menu_screen/blog_details.dart';
import 'package:stayverz_flutter_app/features/public_listings/presentation/views/public_listings_view.dart';

class AppRoute {
  // Route names
  static const String login = '/login';
  static const String host = '/host';
  static const String guest = '/guest';
  static const String blogDetails = '/blog-details';
  static const String publicListings = '/public-listings';

  // Route generator
  static Map<String, Widget Function(BuildContext)> routes = {
    login: (context) => LoginView(),
    host: (context) => const HostBottomNavigationBarView(),
    guest: (context) => const GuestBottomNavigationBarView(),
    publicListings: (context) => PublicListingsView(),
    blogDetails: (context) {
      final blog = ModalRoute.of(context)!.settings.arguments as DataItem?;
      return BlogDetails(blog: blog);
    },
  };

  // Helper methods for navigation
  static void toBlogDetails(DataItem blog) {
    Get.toNamed(blogDetails, arguments: blog);
  }
}
// Hello I am Tamim