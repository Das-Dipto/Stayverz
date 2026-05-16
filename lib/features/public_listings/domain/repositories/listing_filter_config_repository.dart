import 'package:dartz/dartz.dart';
import 'package:stayverz_flutter_app/core/error/failures.dart';
import 'package:stayverz_flutter_app/features/public_listings/data/models/listing_filter_config_model.dart';

abstract class ListingFilterConfigRepository {
  Future<Either<Failure, ListingFilterConfigResponse>> getFilterConfigurations();
}

// Hello I am Tamim