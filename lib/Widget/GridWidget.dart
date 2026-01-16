import 'package:flutter/material.dart';

import 'CachedImageWidget.dart';

class GridWidget extends StatefulWidget {
  final String title;
  final bool circularGrid;
  final List<String> names;
  final List<String> images;
  final Function(String name)? onTap;

  const GridWidget({
    Key? key,
    required this.title,
    this.circularGrid = false,
    required this.names,
    required this.images,
    this.onTap,
  }) : super(key: key);

  @override
  State<GridWidget> createState() => _GridWidgetState();
}

class _GridWidgetState extends State<GridWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(widget.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),
        GridView.builder(
          padding: const EdgeInsets.only(top: 8, left: 8),
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => widget.onTap?.call(widget.names[index]),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,

                children: [
                  (widget.circularGrid)
                      ? Expanded(
                        child: ClipOval(child: CachedImageWidget(image: widget.images[index], width: double.infinity)),
                      )
                      : Expanded(
                        child: ClipRRect(child: CachedImageWidget(image: widget.images[index], width: double.infinity)),
                      ),
                  const SizedBox(height: 6),
                  Text(
                    widget.names[index],
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
