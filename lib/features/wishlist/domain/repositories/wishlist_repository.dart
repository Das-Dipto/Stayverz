import 'package:dartz/dartz.dart';
import 'package:stayverz_flutter_app/core/error/failures.dart';
import '../../../public_listings/data/models/wish_list_model.dart';

abstract class WishlistRepository {
  // Get all wishlist items for the current user
  Future<Either<Failure, List<WishlistItem>>> getWishlistItems();

  // Add a my_listing to wishlist
  Future<Either<Failure, void>> addToWishlist(int listingId);

  // Remove a my_listing from wishlist
  Future<Either<Failure, void>> removeFromWishlist(int wishlistItemId);

  // Check if a my_listing is in wishlist
  Future<bool> isListingInWishlist(int listingId);
}

// Hello I am Tamim