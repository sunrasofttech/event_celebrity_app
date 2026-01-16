import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Widget/CachedImageWidget.dart';

class NearYouComponent extends StatefulWidget {
  const NearYouComponent({super.key});

  @override
  State<NearYouComponent> createState() => _NearYouComponentState();
}

class _NearYouComponentState extends State<NearYouComponent> {
  final events = [
    {
      "imageUrl": "https://i.imgur.com/xwL9K5y.png",
      "title": "Ratnagiri 4.0",
      "location": "Lande Lawns, Pune",
      "time": "Today, 6:00 PM",
    },
    {
      "imageUrl": "https://4kwallpapers.com/images/walls/thumbs_3t/23702.jpg",
      "title": "Pitcher Perfect Tuesdays",
      "location": "Malaka Spice, Pune",
      "time": "Today, 7:40 PM",
    },
    {
      "imageUrl": "https://4kwallpapers.com/images/walls/thumbs_3t/22818.jpg",
      "title": "Sattva at Farro",
      "location": "Farro, Pune",
      "time": "Today, 7:00 PM",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Each EventCardWidget is ~100px tall (example)
        final double cardHeight = 100;
        final int eventCount = 3;
        final double totalHeight = 55 + (eventCount * cardHeight);
        return SizedBox(
          height: totalHeight,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children:
                events.map((event) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.85, // width for each card
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Color(0xFFECECEC), width: 0.5),
                    ),
                    margin: const EdgeInsets.only(left: 12, right: 8, top: 4, bottom: 4),
                    padding: const EdgeInsets.only(top: 18, left: 18, right: 18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        /// Header Row (Today + Arrow)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text("Today ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                Text("(11 events)", style: TextStyle(color: Colors.grey.shade600)),
                              ],
                            ),
                            Icon(IconsaxPlusBold.arrow_right, color: Colors.grey.shade600),
                          ],
                        ),

                        const SizedBox(height: 12),

                        /// Event Cards (use Column, not ListView)
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            3,
                            (i) => EventCardWidget(
                              imageUrl: event['imageUrl']!,
                              title: event['title']!,
                              location: event['location']!,
                              time: event['time']!,
                              onTap: () => print('Tapped on ${event['title']}'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        );
      },
    );
  }
}

class EventCardWidget extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String location;
  final String time;
  final VoidCallback? onTap;

  const EventCardWidget({
    Key? key,
    required this.imageUrl,
    required this.title,
    required this.location,
    required this.time,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(color: bgLightGreyColor, borderRadius: BorderRadius.circular(16)),
        width: MediaQuery.of(context).size.width * 0.85,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// Event Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedImageWidget(image: imageUrl, width: 70, height: 70, fit: BoxFit.cover),
            ),

            const SizedBox(width: 14),

            /// Text Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Text(
                    title,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  /// Location
                  Text(
                    location,
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w400, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  /// Time
                  Text(time, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: pinkTintColor)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
