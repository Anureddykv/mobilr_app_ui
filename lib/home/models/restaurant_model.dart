// lib/home/models/restaurant_model.dart

class RestaurantModel {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String? cuisineType;
  final String? eta;
  final String? address;
  final List<String> offers;
  final String? eventTitle;
  final String? eventDate;
  final String? eventDescription;
  final String? joinLink;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    this.cuisineType,
    this.eta,
    this.address,
    required this.offers,
    this.eventTitle,
    this.eventDate,
    this.eventDescription,
    this.joinLink,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      // Use null-coalescing for safety, providing a unique fallback for 'id'.
      id: json['id'] as String? ??
          'res_${DateTime.now().millisecondsSinceEpoch}',
      // The JSON uses 'name' and 'description' for community items.
      name: json['name'] as String? ?? 'Unknown Restaurant',
      imageUrl: json['imageUrl'] as String? ??
          'https://via.placeholder.com/355x200?text=No+Image',
      // Safely parse numbers that could be int or double.
      rating: (json['rating'] as num? ?? 0.0).toDouble(),
      // Handle various optional fields.
      cuisineType: json['cuisineType'] as String?,
      eta: json['eta'] as String?,
      address: json['address'] as String?,
      // Safely parse a list of strings for offers.
      offers: List<String>.from(json['offers'] as List? ?? []),
      eventTitle: json['eventTitle'] as String?,
      eventDate: json['eventDate'] as String?,
      eventDescription: json['eventDescription'] as String?,
      joinLink: json['joinLink'] as String?,
    );
  }

factory RestaurantModel.fromApi(Map<String, dynamic> json) {
  return RestaurantModel(
    id: json['_id']?.toString() ??
        json['id']?.toString() ??
        'res_${DateTime.now().millisecondsSinceEpoch}',

    name: json['name'] ??
        json['title'] ??
        'Unknown Restaurant',

    imageUrl:
        (json['gallery'] != null &&
                (json['gallery'] as List).isNotEmpty)
            ? json['gallery'][0].toString()
            : json['imageUrl'] ??
                json['poster'] ??
                json['thumbnail'] ??
                'https://via.placeholder.com/355x200?text=No+Image',

    // ✅ FIXED RATING
    rating:
        (json['rating'] is Map
                ? json['rating']['star']
                : json['rating']) is num
            ? ((json['rating'] is Map
                    ? json['rating']['star']
                    : json['rating']) as num)
                .toDouble()
            : 0.0,

    // ✅ FIXED CATEGORY
    cuisineType:
        json['categories'] is List
            ? (json['categories'] as List).join(', ')
            : json['cuisineType'] ??
                json['cuisine'] ??
                json['category'],

    eta: json['eta']?.toString() ?? "25-30 mins",

    // ✅ FIXED ADDRESS
    address:
        json['address'] is Map
            ? "${json['address']['street'] ?? ''}, "
              "${json['address']['city'] ?? ''}"
            : json['address']?.toString(),

    offers: (json['offers'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [],

    eventTitle: json['eventTitle']?.toString(),

    eventDate: json['eventDate']?.toString(),

    eventDescription: json['eventDescription']?.toString(),

    joinLink: json['joinLink']?.toString(),
  );
}
}

class RestaurantDataModel {
  final List<RestaurantModel> featured;
  final List<RestaurantModel> trending;
  final List<RestaurantModel> upcoming;
  final List<RestaurantModel> communities;

  RestaurantDataModel({
    required this.featured,
    required this.trending,
    required this.upcoming,
    required this.communities,
  });

  factory RestaurantDataModel.fromJson(Map<String, dynamic> json) {
    // Helper function to safely parse lists of objects.
    List<RestaurantModel> _parseList(String key) {
      if (json[key] is List) {
        return (json[key] as List)
            .map((item) => RestaurantModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
      return []; // Return an empty list if the key is missing or not a list.
    }

    return RestaurantDataModel(
      featured: _parseList('featured'),
      trending: _parseList('trending'),
      upcoming: _parseList('upcoming'),
      communities: _parseList('communities'),
    );
  }
}
