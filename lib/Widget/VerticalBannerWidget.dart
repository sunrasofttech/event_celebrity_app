import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

import '../Utility/MainColor.dart';
import 'CachedImageWidget.dart';

class VerticalBannerWidget extends StatefulWidget {
  final String title;
  final List<String> images;
  final Function(String image)? onTap;

  const VerticalBannerWidget({Key? key, required this.title, required this.images, this.onTap}) : super(key: key);

  @override
  State<VerticalBannerWidget> createState() => _VerticalBannerWidgetState();
}

class _VerticalBannerWidgetState extends State<VerticalBannerWidget> {
  int _currentIndex = 0;
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 380,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.8, initialPage: widget.images.length > 1 ? 1 : 0),
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final scale = _currentIndex == index ? 1.0 : 0.9; // scale center one larger

              return AnimatedScale(
                scale: scale,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: GestureDetector(
                  onTap: () => widget.onTap?.call(image),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                    decoration: BoxDecoration(color: lightBlackColor, borderRadius: BorderRadius.circular(20)),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        /// Event Image
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                            child: CachedImageWidget(image: image, width: double.infinity, fit: BoxFit.cover),
                          ),
                        ),

                        /// Info Section
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: const BoxDecoration(
                            color: lightBlackColor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        height: 1.3,
                                      ),
                                    ),
                                  ),
                                  const Icon(IconsaxPlusBold.save_2, size: 20, color: Colors.white70),
                                ],
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                "Sun, 23 Nov, 5:00 PM",
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: pinkTintColor),
                              ),
                              const SizedBox(height: 3),
                              Row(
                                children: [
                                  const Icon(IconsaxPlusBold.location, size: 14, color: Colors.white60),
                                  const SizedBox(width: 6),
                                  const Expanded(
                                    child: Text(
                                      "Location Road",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white70,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Rs. 17000/-",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white70),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.images.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _currentIndex == index ? 10 : 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: _currentIndex == index ? Colors.black : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}
