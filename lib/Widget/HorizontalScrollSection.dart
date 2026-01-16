import 'package:flutter/material.dart';

import 'CachedImageWidget.dart';

class HorizontalScrollSection extends StatefulWidget {
  final String title;
  final List<String> images;
  final List<String> names;
  final Function(String name)? onTap;

  const HorizontalScrollSection({Key? key, required this.title, required this.images, required this.names, this.onTap})
    : super(key: key);

  @override
  State<HorizontalScrollSection> createState() => _HorizontalScrollSectionState();
}

class _HorizontalScrollSectionState extends State<HorizontalScrollSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(widget.images.length, (index) {
                return Container(
                  margin: const EdgeInsets.only(left: 8, right: 2),
                  height: 180,
                  width: 100,
                  child: GestureDetector(
                    onTap: () => widget.onTap?.call(widget.names[index]),
                    child: Column(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: CachedImageWidget(image: widget.images[index], width: 200),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(widget.names[index], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }
}
