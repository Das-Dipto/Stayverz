import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stayverz_flutter_app/core/constants/app_routes.dart';
import 'package:stayverz_flutter_app/features/profile/controllers/host_public_profile_controller.dart';
import 'package:stayverz_flutter_app/features/profile/models/host_listing_item_model.dart';

class HostPublicProfileView extends GetView<HostPublicProfileController> {
  const HostPublicProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final String hostId = (Get.arguments?['hostId'] ?? '').toString();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (hostId.isNotEmpty) {
        controller.loadHostProfile(hostId);
        controller.loadHostListings();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text('Host profile'),
      ),
      body: Obx(() {
        if (controller.isLoadingProfile.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.hasError.value || controller.hostProfile.value == null) {
          return const Center(child: Text('Unable to load host profile.'));
        }

        final host = controller.hostProfile.value!;
        final details = host.profile;

        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // --- Host card ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: (host.image != null && host.image!.isNotEmpty)
                        ? CachedNetworkImageProvider(host.image!)
                        : null,
                    child: (host.image == null || host.image!.isEmpty)
                        ? const Icon(Icons.person, size: 40, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    host.fullName ?? '${host.firstName} ${host.lastName}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        '${host.avgRating?.toStringAsFixed(2) ?? "0.00"} · ${host.totalRatingCount ?? 0} reviews',
                        style: const TextStyle(color: Colors.black54, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (host.isPhoneVerified == true || host.isEmailVerified == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Confirmed information",
                            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (host.isPhoneVerified == true) _verifiedRow('Phone number'),
                        if (host.isEmailVerified == true) _verifiedRow('Email address'),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // --- About section ---
            Text(
              'About ${host.firstName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),

            if (details?.work.isNotEmpty == true)
              _infoRow(Icons.work_outline, 'My work: ${details!.work}'),
            if (details?.address.isNotEmpty == true)
              _infoRow(Icons.location_on_outlined, 'Where I live: ${details!.address}'),
            if (details?.languages.isNotEmpty == true)
              _infoRow(Icons.chat_bubble_outline,
                  'Languages I speak: ${details!.languages.join(", ")}'),

            if (details?.bio.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              Text(
                details!.bio,
                style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
              ),
            ],

            const SizedBox(height: 28),

            // --- Properties by this host ---
            const Text(
              'Properties by this host',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Obx(() => Text(
                  '${controller.verifiedListings.length} properties available',
                  style: const TextStyle(color: Colors.black54, fontSize: 13),
                )),
            const SizedBox(height: 16),

            Obx(() {
              if (controller.isLoadingListings.value) {
                return SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (_, __) => Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      child: Container(
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                );
              }

              if (controller.verifiedListings.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: Text(
                      'No verified properties yet.',
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 250,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.verifiedListings.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 14),
                  itemBuilder: (context, index) {
                    final listing = controller.verifiedListings[index];
                    return _PropertyCard(listing: listing);
                  },
                ),
              );
            }),

            const SizedBox(height: 30),
          ],
        );
      }),
    );
  }

  Widget _verifiedRow(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.verified, size: 16, color: Colors.deepOrangeAccent),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14, height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _PropertyCard extends StatelessWidget {
  final HostListingItemModel listing;
  const _PropertyCard({required this.listing});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          AppRoute.publicListings,
          arguments: {'id': listing.uniqueId},
        );
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 130,
              width: double.infinity,
              child: (listing.coverPhoto.isNotEmpty)
                  ? CachedNetworkImage(
                      imageUrl: listing.coverPhoto,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(color: Colors.grey.shade200),
                      errorWidget: (_, __, ___) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported_outlined),
                      ),
                    )
                  : Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.home_outlined, size: 32, color: Colors.grey),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    listing.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.king_bed_outlined, size: 14, color: Colors.black45),
                      const SizedBox(width: 3),
                      Text('${listing.bedCount} bed', style: const TextStyle(fontSize: 11)),
                      const SizedBox(width: 8),
                      const Icon(Icons.bathtub_outlined, size: 14, color: Colors.black45),
                      const SizedBox(width: 3),
                      Text('${listing.bathroomCount} bath', style: const TextStyle(fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '৳${listing.price.toStringAsFixed(0)} / night',
                    style: const TextStyle(
                      color: Color(0xFFF15925),
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}