class GuestBlogModel {
  final bool success;
  final int statusCode;
  final String message;
  final MetaData metaData;
  final List<DataItem> data;

  GuestBlogModel({
    required this.success,
    required this.statusCode,
    required this.message,
    required this.metaData,
    required this.data,
  });

  factory GuestBlogModel.fromJson(Map<String, dynamic> json) {
    return GuestBlogModel(
      success: json['success'] ?? false,
      statusCode: json['status_code'] ?? 0,
      message: json['message'] ?? '',
      metaData: MetaData.fromJson(json['meta_data'] ?? {}),
      data: (json['data'] != null && json['data'] is List)
          ? List<DataItem>.from(json['data'].map((item) => DataItem.fromJson(item)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'status_code': statusCode,
      'message': message,
      'meta_data': metaData.toJson(),
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}

class MetaData {
  final int total;
  final int pageSize;
  final dynamic next;
  final dynamic previous;

  MetaData({
    required this.total,
    required this.pageSize,
    this.next,
    this.previous,
  });

  factory MetaData.fromJson(Map<String, dynamic> json) {
    // Handle both string and int types for page_size
    final dynamic pageSize = json['page_size'];
    final int parsedPageSize = pageSize is String ? int.tryParse(pageSize) ?? 0 : 
                              pageSize is int ? pageSize : 0;
                              
    return MetaData(
      total: json['total'] is int ? json['total'] : 
            json['total'] is String ? int.tryParse(json['total']) ?? 0 : 0,
      pageSize: parsedPageSize,
      next: json['next'],
      previous: json['previous'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total': total,
      'page_size': pageSize,
      'next': next,
      'previous': previous,
    };
  }
}

class DataItem {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String title;
  final String slug;
  final String description;
  final String image;
  final String status;

  DataItem({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.slug,
    required this.description,
    required this.image,
    required this.status,
  });

  factory DataItem.fromJson(Map<String, dynamic> json) {
    return DataItem(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'title': title,
      'slug': slug,
      'description': description,
      'image': image,
      'status': status,
    };
  }
}

// Hello I am Tamim