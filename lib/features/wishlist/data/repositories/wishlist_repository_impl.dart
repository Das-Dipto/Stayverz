import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:stayverz_flutter_app/core/error/failures.dart';
import 'package:stayverz_flutter_app/features/wishlist/domain/repositories/wishlist_repository.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';
import '../../../public_listings/data/models/wish_list_model.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final ApiClient _apiClient = Get.find<ApiClient>();
  final String _basePath = '/wishlists/user/wishlist-items';

  @override
  Future<Either<Failure, List<WishlistItem>>> getWishlistItems() async {
    try {
      final response = await _apiClient.get(_basePath);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];

        final wishlistItems =
        data.map((item) => WishlistItem.fromJson(item)).toList();

        return Right(wishlistItems);
      } else {
        return Left(ServerFailure(message: 'Failed to load wishlist'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(int listingId) async {
    try {
      final response = await _apiClient.post(
        "$_basePath/",
        data: jsonEncode({'listing_id': listingId}),
      );

      if (response.statusCode == 201) {
        return const Right(null);
      } else if (response.statusCode == 400) {
        return Left(ServerFailure(message: 'Listing already in wishlist'));
      } else {
        return Left(ServerFailure(message: 'Failed to add to wishlist'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(int wishlistItemId) async {
    try {
      final response = await _apiClient.delete('$_basePath/$wishlistItemId/');

      if (response.statusCode == 200) {
        return const Right(null);
      } else if (response.statusCode == 404) {
        return Left(ServerFailure(message: 'Wishlist item not found'));
      } else {
        return Left(ServerFailure(message: 'Failed to remove from wishlist'));
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'An unexpected error occurred'));
    }
  }

  @override
  Future<bool> isListingInWishlist(int listingId) async {
    try {
      final result = await getWishlistItems();
      return result.fold(
        (failure) => false,
        (wishlistItems) =>
            wishlistItems.any((item) => item.listing?.id == listingId),
      );
    } catch (e) {
      return false;
    }
  }
}

// Hello I am Tamim