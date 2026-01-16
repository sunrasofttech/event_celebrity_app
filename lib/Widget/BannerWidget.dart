import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'CachedImageWidget.dart';

class BannerWidget extends StatefulWidget {
  final String title;
  final List<String> images;
  final Function(String)? onTap;

  const BannerWidget({super.key, required this.title, required this.images, this.onTap});

  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  int _currentIndex = 0;
  final CarouselSliderController _carouselController = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),

        /// Carousel Slider
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: widget.images.length,
          options: CarouselOptions(
            height: 160,
            enlargeCenterPage: true,
            viewportFraction: 1, // 85% width → next one peeks
            enableInfiniteScroll: true,
            enlargeStrategy: CenterPageEnlargeStrategy.scale,
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final image = widget.images[index];
            return GestureDetector(
              onTap: () => widget.onTap?.call(image),
              child: Container(
                width: width,
                margin: const EdgeInsets.only(left: 8, right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 4))],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: CachedImageWidget(image: image, width: width, height: 160, fit: BoxFit.cover),
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 8),

        /*/// Dots Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.images.length, (index) {
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _currentIndex == index ? 10 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: _currentIndex == index ? Colors.black : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            );
          }),
        ),*/
      ],
    );
  }
}
