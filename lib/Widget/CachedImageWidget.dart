import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class CachedImageWidget extends StatelessWidget {
  const CachedImageWidget({super.key, required this.image, this.width, this.height, this.fit});
  final String image;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: image,
        fit: fit ?? BoxFit.cover,
        placeholder:
            (context, url) =>
                SizedBox(height: height, width: width, child: const Center(child: CircularProgressIndicator())),
        errorWidget:
            (context, url, error) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
              child: Icon(IconsaxPlusBold.folder_cross),
            ),
      ),
    );
  }
}
