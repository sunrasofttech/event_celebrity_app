import 'package:flutter/material.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:planner_celebrity/Bloc/get_dashboard/get_dashboard_model.dart';
import 'package:planner_celebrity/UI/Pages/event_detail_screen.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Utility/const.dart';

class AllEventsScreen extends StatelessWidget {
  final List<UpcomingEvent>? events;

  const AllEventsScreen({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: blackColor),
        title: const Text("All Events", style: TextStyle(color: blackColor)),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: events?.length ?? 0,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final booking = events?[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => EventDetailsScreen(eventId: booking?.id ?? "")),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black12.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Event Image
                  ClipRRect(
                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
                    child: Image.network(
                      "${Constants.baseUrl}/${booking?.coverImageUrl ?? ""}",
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  /// Event Details
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking?.eventName ?? "",
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),

                        const SizedBox(height: 6),

                        /// Date
                        Row(
                          children: [
                            Icon(IconsaxPlusBold.calendar_1, size: 14, color: greyColor),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                formatEventDates(booking?.eventDate ?? []),
                                style: TextStyle(color: greyColor, fontSize: 13),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),

                        /// Time
                        Row(
                          children: [
                            Icon(IconsaxPlusBold.timer, size: 14, color: greyColor),
                            const SizedBox(width: 6),
                            Text(booking?.entryTime ?? "", style: TextStyle(color: greyColor, fontSize: 13)),
                          ],
                        ),

                        const SizedBox(height: 6),

                        /// Address
                        if (booking?.eventAddress != null)
                          Row(
                            children: [
                              Icon(IconsaxPlusBold.location, size: 14, color: greyColor),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  booking?.eventAddress ?? "",
                                  style: TextStyle(color: greyColor, fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String formatEventDates(List<String> dates) {
    if (dates.isEmpty) return "";

    final parsedDates = dates.map((e) => DateTime.tryParse(e)).whereType<DateTime>().toList()..sort();

    if (parsedDates.isEmpty) return "";

    // Single date
    if (parsedDates.length == 1) {
      return DateFormat("EEE, d MMM").format(parsedDates.first);
    }

    // Multiple dates → range
    final first = parsedDates.first;
    final last = parsedDates.last;

    // Same month
    if (first.month == last.month && first.year == last.year) {
      return "${first.day}–${last.day} ${DateFormat("MMM").format(first)}";
    }

    // Different months
    return parsedDates.map((d) => DateFormat("d MMM").format(d)).join(", ");
  }
}
