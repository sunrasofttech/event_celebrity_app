import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:planner_celebrity/Bloc/EventDetailsBloc/EventDetailsCubit.dart';
import 'package:planner_celebrity/Bloc/EventDetailsBloc/EventDetailsModel.dart';
import 'package:planner_celebrity/Bloc/EventDetailsBloc/EventDetailsState.dart';
import 'package:planner_celebrity/UI/Pages/CalendarScreen.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';
import 'package:planner_celebrity/Widget/CachedImageWidget.dart';

import '../../Utility/const.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key, required this.eventId});
  final String eventId;
  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  int _currentIndex = 0;

  final events = [
    {
      "imageUrl": "https://4kwallpapers.com/images/walls/thumbs_3t/22818.jpg",
      "title": "Ratnagiri 4.0",
      "location": "Lande Lawns, Pune",
      "time": "Today, 6:00 PM",
    },
    {
      "imageUrl": "https://i.imgur.com/xwL9K5y.png",
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

  final List<String> imageList = [
    "https://4kwallpapers.com/images/walls/thumbs_3t/22818.jpg",
    "https://4kwallpapers.com/images/walls/thumbs_3t/23702.jpg",
    "https://i.imgur.com/xwL9K5y.png",
  ];

  @override
  void initState() {
    context.read<EventDetailsCubit>().getEventDetails(widget.eventId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventDetailsCubit, EventDetailsState>(
        builder: (context, state) {
          if (state is EventDetailsLoadingState) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _backButton(),
                  Expanded(
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                ],
              ),
            );
          }

          if (state is EventDetailsErrorState) {
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _backButton(),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            IconsaxPlusLinear.close_circle,
                            color: primaryColor,
                            size: 120,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            state.error,
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is! EventDetailsLoadedState) {
            return const SizedBox.shrink();
          }

          if (state.model.data != null) {
            final data = state.model.data!;

            // --- Single Image List (API provides only one image)
            final List<String> imageList = [
              "${Constants.baseUrl}/${data.coverImageUrl}",
            ];

            return _buildUI(context, data, imageList);
          }

          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildUI(
    BuildContext context,
    EventData data,
    List<String> imageList,
  ) {
    return CustomScrollView(
      slivers: [
        // ---------------- SliverAppBar ---------------------
        SliverAppBar(
          pinned: true,
          expandedHeight: 360,
          backgroundColor: Colors.white,
          leading: _backButton(),
          actions: _headerActions(),
          flexibleSpace: _eventImages(imageList),
        ),

        // ----------------- BODY ---------------------------
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTag("Music"),

                const SizedBox(height: 8),

                // -------- Event Name --------
                Text(
                  data.eventName ?? "",
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: titleTextColor,
                  ),
                ),

                // -------- Event Date --------
                Text(
                  formatEventDates(data.eventDate ?? []),
                  style: const TextStyle(fontSize: 12, color: primaryColor),
                ),

                const SizedBox(height: 12),

                _locationCard(data),
                const SizedBox(height: 16),

                _scheduleCard(data),
                const SizedBox(height: 20),

                ///GALLERY
                _galleryWidget(data),

                _aboutSection(data),
                const SizedBox(height: 20),

                _celebritiesSection(data.celebrities ?? []),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _eventImages(List<String> imageList) {
    return FlexibleSpaceBar(
      background: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(16),
            ),
            child: CarouselSlider(
              items:
                  imageList
                      .map(
                        (url) => Image.network(
                          url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      )
                      .toList(),
              options: CarouselOptions(
                height: 400,
                viewportFraction: 1.0,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() => _currentIndex = index);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  imageList.asMap().entries.map((entry) {
                    return Container(
                      width: _currentIndex == entry.key ? 10 : 6,
                      height: _currentIndex == entry.key ? 10 : 6,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _currentIndex == entry.key
                                ? Colors.white
                                : Colors.white54,
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _aboutSection(EventData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "ABOUT THE EVENT",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: blackColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.shortBio?.toString() ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                  "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.\n\n"
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                  "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            height: 1.5,
          ),
        ),
        SizedBox(height: 15),
        Text(
          "Age Limit",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: blackColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.ageLimit?.toString() ?? "",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            height: 1.5,
          ),
        ),
        SizedBox(height: 15),
        Text(
          "Term & Condition",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: blackColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.termsAndConditions?.toString() ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                  "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.\n\n"
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                  "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            height: 1.5,
          ),
        ),
        SizedBox(height: 15),
        Text(
          "Language",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: blackColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.languages?.toString() ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                  "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.\n\n"
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                  "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            height: 1.5,
          ),
        ),
        SizedBox(height: 15),
        Text(
          "Disclamer",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: blackColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.disclamer?.toString() ??
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                  "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.\n\n"
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                  "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade800,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  List<Widget> _headerActions() {
    return [
      // Container(
      //   margin: const EdgeInsets.all(8),
      //   decoration: BoxDecoration(
      //     color: Colors.white.withOpacity(0.8),
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      //   child: IconButton(
      //     icon: const Icon(IconsaxPlusBold.share, color: greyColor),
      //     onPressed: () {},
      //   ),
      // ),
      // Container(
      //   margin: const EdgeInsets.all(8),
      //   decoration: BoxDecoration(
      //     color: Colors.white.withOpacity(0.8),
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      //   child: IconButton(
      //     icon: const Icon(IconsaxPlusBold.bookmark, color: greyColor),
      //     onPressed: () {},
      //   ),
      // ),
    ];
  }

  Widget _backButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: IconButton(
        icon: const Icon(IconsaxPlusBold.arrow_left_3, color: greyColor),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Widget _locationCard(EventData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _whiteBox(),
      child: Row(
        children: [
          const Icon(IconsaxPlusBold.location, color: greyColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   data.eventPlace ?? "Location not provided",
                //   style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                // ),
                Text(
                  "${data.eventAddress ?? "No Address Found"}",
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _scheduleCard(EventData data) {
    return Container(
      decoration: _whiteBox(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(IconsaxPlusBold.calendar_tick, color: greyColor),
              const SizedBox(width: 8),
              Text(
                "Entry Time: ${_formatTime(data.entryTime)}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Text(
            "Schedule & Timeline",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),

          const SizedBox(height: 12),

          _buildTimelineSection(
            "Gates Open",
            _formatTime(data.entryTime),
            false,
          ),
          _buildTimelineSection(
            "Show Starts",
            _formatTime(data.showStartTime),
            false,
          ),
          _buildTimelineSection(
            "Show Ends",
            _formatTime(data.showEndTime),
            true,
          ),
        ],
      ),
    );
  }

  Widget _celebritiesSection(List<Celebrity> celebs) {
    if (celebs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Celebrities",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),

        const SizedBox(height: 8),

        ...celebs.map(
          (c) => ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                "${Constants.baseUrl}/${c.profilePictureUrl}",
              ),
            ),
            title: Text(c.fullName ?? ""),
          ),
        ),
      ],
    );
  }

  Widget _galleryWidget(EventData data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gallery",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: titleTextColor,
          ),
        ),
        const SizedBox(height: 8),
        GridView.custom(
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          primary: false,
          gridDelegate: SliverQuiltedGridDelegate(
            crossAxisCount: 4,
            mainAxisSpacing: 4,
            crossAxisSpacing: 4,
            repeatPattern: QuiltedGridRepeatPattern.inverted,
            pattern: [
              QuiltedGridTile(2, 2),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 1),
              QuiltedGridTile(1, 2),
            ],
          ),
          childrenDelegate: SliverChildBuilderDelegate(
            childCount: 12,
            (context, index) => CachedImageWidget(
              image: "${Constants.baseUrl}/${data.coverImageUrl}",
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  String formatEventDates(List<String>? dates) {
    if (dates == null || dates.isEmpty) return "";

    try {
      return dates
          .map((iso) {
            final d = DateTime.parse(iso);
            return DateFormat("EEE, d MMM").format(d);
          })
          .join(", ");
    } catch (_) {
      return "";
    }
  }

  String _formatTime(String? time) {
    if (time == null) return "";
    try {
      final parts = time.split(":");
      final dt = DateTime(2024, 1, 1, int.parse(parts[0]), int.parse(parts[1]));
      return DateFormat("h:mm a").format(dt);
    } catch (_) {
      return time;
    }
  }

  BoxDecoration _whiteBox() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
    );
  }

  Widget _buildTag(String text) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: greyColor.withOpacity(0.2), width: 0.5),
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    child: Text(
      text,
      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
    ),
  );

  Widget _buildTimelineSection(String label, String time, bool isLast) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // LEFT PART : Circle + Vertical Line
        Column(
          children: [
            // circle
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: greyColor, width: 2),
              ),
            ),

            // vertical line (hidden for last)
            if (!isLast)
              Container(width: 2, height: 40, color: Colors.grey.shade300),
          ],
        ),

        const SizedBox(width: 12),

        // LABEL + TIME
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 15, color: Colors.grey.shade700),
                ),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  ///-------------------------- DEPRECIATED --------------------------///
  Widget _UIWithoutAPI() {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ---------- Collapsing AppBar with Carousel ----------
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 360,
            backgroundColor: Colors.white,
            elevation: 0,
            leading: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: IconButton(
                icon: const Icon(
                  IconsaxPlusBold.arrow_left_3,
                  color: greyColor,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(IconsaxPlusBold.share, color: greyColor),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  icon: const Icon(IconsaxPlusBold.bookmark, color: greyColor),
                  onPressed: () {},
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                    child: CarouselSlider(
                      items:
                          imageList
                              .map(
                                (url) => Image.network(
                                  url,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              )
                              .toList(),
                      options: CarouselOptions(
                        height: 400,
                        viewportFraction: 1.0,
                        autoPlay: true,
                        onPageChanged: (index, reason) {
                          setState(() => _currentIndex = index);
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:
                          imageList.asMap().entries.map((entry) {
                            return Container(
                              width: _currentIndex == entry.key ? 10 : 6,
                              height: _currentIndex == entry.key ? 10 : 6,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    _currentIndex == entry.key
                                        ? Colors.white
                                        : Colors.white54,
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ---------- Body ----------
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tags
                  Row(
                    children: [
                      _buildTag("Celebration"),
                      const SizedBox(width: 8),
                      _buildTag("Concert"),
                      const SizedBox(width: 8),
                      _buildTag("Music"),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Title & Time
                  Text(
                    "Diwali Dhamaka",
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: titleTextColor,
                    ),
                  ),
                  Text(
                    "Sun, 5 Oct, 7:00 PM",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: pinkTintColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Location
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(
                          IconsaxPlusBold.location,
                          color: greyColor,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Mumbai",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "140 Km away",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Schedule Card
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ENTRY TIME
                        Row(
                          children: [
                            const Icon(
                              IconsaxPlusBold.calendar_tick,
                              color: greyColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              "Entry Time: 5:50 PM",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.keyboard_arrow_up_rounded,
                              size: 22,
                            ),
                          ],
                        ),

                        const SizedBox(height: 6),
                        Text(
                          "View Full Schedule and time",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          "Schedule and Timeline",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // _buildTimelineSection("Tue, 30 Sep", [
                        //   ("Gates Open", "5:00 PM"),
                        //   ("Show starts", "6:00 PM"),
                        //   ("Show ends", "11:59 PM"),
                        // ]),
                        const SizedBox(height: 20),

                        // _buildTimelineSection("Wed, 1 Oct", [("Gates Open", "5:00 PM"), ("Show starts", "6:00 PM")]),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // About
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ABOUT THE EVENT",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: greyColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.\n\n"
                        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. "
                        "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s.",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade800,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),

                  //Gallery
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Gallery",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: titleTextColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      GridView.custom(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        gridDelegate: SliverQuiltedGridDelegate(
                          crossAxisCount: 4,
                          mainAxisSpacing: 4,
                          crossAxisSpacing: 4,
                          repeatPattern: QuiltedGridRepeatPattern.inverted,
                          pattern: [
                            QuiltedGridTile(2, 2),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 1),
                            QuiltedGridTile(1, 2),
                          ],
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                          childCount: 12,
                          (context, index) => CachedImageWidget(
                            image:
                                "https://4kwallpapers.com/images/walls/thumbs_3t/23702.jpg",
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Organizers
                  const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Organizers",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: greyColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 160,
                              child: Row(
                                children: [
                                  CachedImageWidget(
                                    image: "image",
                                    height: 160,
                                    width: 140,
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Spacer(flex: 2),
                                      Text(
                                        "Title",
                                        style: TextStyle(
                                          color: titleTextColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        "Subtitle",
                                        style: TextStyle(
                                          color: greyColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const Spacer(flex: 2),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ],
      ),

      // ---------- Bottom Button ----------
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFEDEDED))),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text(
                    "₹300",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "onwards",
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
              SimpleButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CalendarScreen()),
                  );
                },
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                title: "Book Tickets",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
