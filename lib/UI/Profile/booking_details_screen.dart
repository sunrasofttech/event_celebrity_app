import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';

class BookingDetailsScreen extends StatefulWidget {
  const BookingDetailsScreen({super.key});

  @override
  State<BookingDetailsScreen> createState() => _BookingDetailsScreenState();
  

  static Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  }

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: scaffoldBgColor,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(4), color: Colors.white),
            child: const Icon(IconsaxPlusBold.arrow_left_3, color: greyColor),
          ),
          onPressed: () => Navigator.pop(context),
        ),
    
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Title
              const Text(
                "Roxfire Roxx",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              /// Booking Amount Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Booking Amount",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  Text(
                    "₹ 78,500",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Date
              BookingDetailsScreen._infoRow(Icons.calendar_today, "Sunday, 01 October, 2025"),

              const SizedBox(height: 10),

              /// Time
              BookingDetailsScreen._infoRow(Icons.access_time, "7:00 PM"),

              const SizedBox(height: 10),

              /// Location
              BookingDetailsScreen._infoRow(Icons.location_on, "Roxx Garden"),

              const SizedBox(height: 16),

              /// Description
              const Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 24),

              /// Location Images Title
              const Text(
                "Location Images",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              /// STAGGERED GRID (EXACT LIKE SCREENSHOT)
            StaggeredGrid.count(
  crossAxisCount: 2,
  mainAxisSpacing: 12,
  crossAxisSpacing: 12,
  children: List.generate(imageList.length, (index) {
    return StaggeredGridTile.fit(
      crossAxisCellCount: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
          // ZIP-ZAP HEIGHT CONTROL
          aspectRatio: index.isEven ? 1 / 1.2 : 1 / 1.6,
          child: Image.network(
            imageList[index],
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }),
),

            ],
          ),
        ),
      ),
    );
  }
}
final List<String> imageList = [
  "https://images.unsplash.com/photo-1521334884684-d80222895322",
  "https://images.unsplash.com/photo-1506157786151-b8491531f063",
  "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
  "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7",
  "https://images.unsplash.com/photo-1504384308090-c894fdcc538d",
  "https://images.unsplash.com/photo-1519751138087-5bf79df62d5b",
];