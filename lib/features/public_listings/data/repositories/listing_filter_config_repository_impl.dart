import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import 'package:stayverz_flutter_app/core/error/failures.dart';
import 'package:stayverz_flutter_app/features/public_listings/domain/repositories/listing_filter_config_repository.dart';
import 'package:stayverz_flutter_app/features/public_listings/data/models/listing_filter_config_model.dart';
import 'package:stayverz_flutter_app/services/network/api_client.dart';

class ListingFilterConfigRepositoryImpl
    implements ListingFilterConfigRepository {
  final ApiClient _apiClient;

  ListingFilterConfigRepositoryImpl() : _apiClient = Get.find<ApiClient>();

  @override
  Future<Either<Failure, ListingFilterConfigResponse>>
  getFilterConfigurations() async {
    try {
      final response = await _apiClient.get('/listings/public/configurations/');

      if (response.statusCode == 200) {
        // ✅ FIX: Pass the full response to fromJson()
        return Right(ListingFilterConfigResponse.fromJson(response.data));
      } else {
        return Left(
          ServerFailure(message: 'Failed to load filter configurations'),
        );
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(message: 'Unexpected error occurred'));
    }
  }

}

// Hello I am Tamim