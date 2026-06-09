class ListingModel {
  final int id;
  final double latitude;
  final double longitude;
  final bool instant_booking_allowed;
  final bool require_guest_good_track_record;
  final bool enable_length_of_stay_discount;
  final Map<String, dynamic> length_of_stay_discounts;
  final String created_at;
  final String updated_at;
  final String unique_id;
  final String title;
  final String description;
  final double price;
  final String cover_photo;
  final List<String> images;
  final String place_type;
  final String status;
  final String verification_status;
  final int guest_count;
  final int bedroom_count;
  final int bed_count;
  final int bathroom_count;
  final int minimum_nights;
  final int maximum_nights;
  final String address;
  final bool pet_allowed;
  final bool event_allowed;
  final bool smoking_allowed;
  final bool media_allowed;
  final bool unmarried_couples_allowed;
  final Map<String, dynamic> cancellation_policy;
  final String check_in;
  final String check_out;
  final double avg_rating;
  final double total_rating_sum;
  final int total_rating_count;
  final int total_booking_count;
  final String location;
  final String district;
  final String division;
  final String area;
  final String city;
  final bool is_deleted;
  final String? deleted_at;
  final int host;
  final int? category; // Changed to nullable int

  ListingModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.instant_booking_allowed,
    required this.require_guest_good_track_record,
    required this.enable_length_of_stay_discount,
    required this.length_of_stay_discounts,
    required this.created_at,
    required this.updated_at,
    required this.unique_id,
    required this.title,
    required this.description,
    required this.price,
    required this.cover_photo,
    required this.images,
    required this.place_type,
    required this.status,
    required this.verification_status,
    required this.guest_count,
    required this.bedroom_count,
    required this.bed_count,
    required this.bathroom_count,
    required this.minimum_nights,
    required this.maximum_nights,
    required this.address,
    required this.pet_allowed,
    required this.event_allowed,
    required this.smoking_allowed,
    required this.media_allowed,
    required this.unmarried_couples_allowed,
    required this.cancellation_policy,
    required this.check_in,
    required this.check_out,
    required this.avg_rating,
    required this.total_rating_sum,
    required this.total_rating_count,
    required this.total_booking_count,
    required this.location,
    required this.district,
    required this.division,
    required this.area,
    required this.city,
    required this.is_deleted,
    this.deleted_at,
    required this.host,
    this.category, // Changed to optional parameter
  });

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as int,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      instant_booking_allowed: json['instant_booking_allowed'] as bool,
      require_guest_good_track_record:
      json['require_guest_good_track_record'] as bool,
      enable_length_of_stay_discount:
      json['enable_length_of_stay_discount'] as bool,
      length_of_stay_discounts: (json['length_of_stay_discounts'] is Map)
          ? Map<String, dynamic>.from(json['length_of_stay_discounts'])
          : {},
      created_at: json['created_at'] as String,
      updated_at: json['updated_at'] as String,
      unique_id: json['unique_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      cover_photo: json['cover_photo'] as String,
      images:
      (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      place_type: json['place_type'] as String,
      status: json['status'] as String,
      verification_status: json['verification_status'] as String,
      guest_count: json['guest_count'] as int,
      bedroom_count: json['bedroom_count'] as int,
      bed_count: json['bed_count'] as int,
      bathroom_count: json['bathroom_count'] as int,
      minimum_nights: json['minimum_nights'] as int,
      maximum_nights: json['maximum_nights'] as int,
      address: json['address'] as String,
      pet_allowed: json['pet_allowed'] as bool,
      event_allowed: json['event_allowed'] as bool,
      smoking_allowed: json['smoking_allowed'] as bool,
      media_allowed: json['media_allowed'] as bool,
      unmarried_couples_allowed: json['unmarried_couples_allowed'] as bool,
      cancellation_policy: (json['cancellation_policy'] is Map)
      ? Map<String, dynamic>.from(json['cancellation_policy'])
      : {},
      check_in: json['check_in'] as String,
      check_out: json['check_out'] as String,
      avg_rating: (json['avg_rating'] as num).toDouble(),
      total_rating_sum: (json['total_rating_sum'] as num).toDouble(),
      total_rating_count: json['total_rating_count'] as int,
      total_booking_count: json['total_booking_count'] as int,
      location: json['location'] as String,
      district: json['district'] as String,
      division: json['division'] as String,
      area: json['area'] as String,
      city: json['city'] as String,
      is_deleted: json['is_deleted'] as bool,
      deleted_at: json['deleted_at'] as String?,
      host: json['host'] as int,
      category: json['category'] as int?, // Handle null value
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'instant_booking_allowed': instant_booking_allowed,
      'require_guest_good_track_record': require_guest_good_track_record,
      'enable_length_of_stay_discount': enable_length_of_stay_discount,
      'length_of_stay_discounts': length_of_stay_discounts,
      'created_at': created_at,
      'updated_at': updated_at,
      'unique_id': unique_id,
      'title': title,
      'description': description,
      'price': price,
      'cover_photo': cover_photo,
      'images': images,
      'place_type': place_type,
      'status': status,
      'verification_status': verification_status,
      'guest_count': guest_count,
      'bedroom_count': bedroom_count,
      'bed_count': bed_count,
      'bathroom_count': bathroom_count,
      'minimum_nights': minimum_nights,
      'maximum_nights': maximum_nights,
      'address': address,
      'pet_allowed': pet_allowed,
      'event_allowed': event_allowed,
      'smoking_allowed': smoking_allowed,
      'media_allowed': media_allowed,
      'unmarried_couples_allowed': unmarried_couples_allowed,
      'cancellation_policy': cancellation_policy,
      'check_in': check_in,
      'check_out': check_out,
      'avg_rating': avg_rating,
      'total_rating_sum': total_rating_sum,
      'total_rating_count': total_rating_count,
      'total_booking_count': total_booking_count,
      'location': location,
      'district': district,
      'division': division,
      'area': area,
      'city': city,
      'is_deleted': is_deleted,
      'deleted_at': deleted_at,
      'host': host,
      'category': category,
    };
  }
}

class ListingResponseModel {
  final bool success;
  final int status_code;
  final String message;
  final Map<String, dynamic> meta_data;
  final List<ListingModel> data;

  ListingResponseModel({
    required this.success,
    required this.status_code,
    required this.message,
    required this.meta_data,
    required this.data,
  });

  factory ListingResponseModel.fromJson(Map<String, dynamic> json) {
    return ListingResponseModel(
      success: json['success'] as bool,
      status_code: json['status_code'] as int,
      message: json['message'] as String,
      meta_data: json['meta_data'] as Map<String, dynamic>,
      data:
      (json['data'] as List<dynamic>)
          .map((e) => ListingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_code': status_code,
      'message': message,
      'meta_data': meta_data,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
// Hello I am Tamim