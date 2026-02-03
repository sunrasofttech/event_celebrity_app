import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:planner_celebrity/Bloc/get_all_events/get_all_events_cubit.dart';
import 'package:planner_celebrity/Bloc/get_all_events/get_all_events_model.dart';
import 'package:planner_celebrity/UI/Profile/booking_details_screen.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Utility/const.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // final List<Booking> bookings = [
  //   Booking(
  //     title: "Clestial Echo: The Horizon Live at Eden Garden",
  //     date: "Sunday, 01 October, 2025",
  //     time: "7:00 PM",
  //     location: "Eden Garden",
  //     imageUrl:
  //         "https://plus.unsplash.com/premium_photo-1661306437817-8ab34be91e0c?ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&q=80&w=1170",
  //     amount: "₹ 68,000",
  //   ),
  //   Booking(
  //     title: "Foxfire Roxx",
  //     date: "Sunday, 01 October, 2025",
  //     time: "7:00 PM",
  //     location: "Roxx Garden",
  //     imageUrl: "https://images.unsplash.com/photo-1521737604893-d14cc237f11d?w=800",
  //     amount: "₹ 78,500",
  //   ),
  // ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final redColor = primaryColor;
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7F7),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),

              // Tabs
              TabBar(
                controller: _tabController,
                labelColor: redColor,
                unselectedLabelColor: Colors.grey.shade600,
                labelStyle: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                indicatorColor: redColor,
                indicatorWeight: 2,
                labelPadding: const EdgeInsets.symmetric(horizontal: 20),
                tabs: const [
                  Tab(text: "Upcoming"),
                  Tab(text: "Today"),
                  Tab(text: "Completed"),
                ],
              ),

              const SizedBox(height: 16),

              // Tab Views
              Expanded(
                child: BlocBuilder<GetAllEventsCubit, GetAllEventsState>(
                  builder: (context, state) {
                    if (state is GetAllEventsLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state is GetAllEventsLoadedState) {
                      final data = state.model.data;

                      final upcoming = data?.upcomingEvents ?? [];
                      final today = data?.todayEvents ?? [];
                      final completed = data?.completedEvents ?? [];

                      return TabBarView(
                        controller: _tabController,
                        children: [
                          upcoming.isEmpty
                              ? _buildEmptyState("No upcoming bookings")
                              : _buildBookingList(upcoming),

                          today.isEmpty
                              ? _buildEmptyState("No bookings for today")
                              : _buildBookingList(today),

                          completed.isEmpty
                              ? _buildEmptyState("No completed bookings yet")
                              : _buildBookingList(completed),
                        ],
                      );
                    }

                    if (state is GetAllEventsErrorState) {
                      return Center(child: Text(state.error));
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String formatEventDates(List<String>? dates) {
    if (dates == null || dates.isEmpty) return "";

    try {
      return dates
          .map((d) => DateFormat("EEE, d MMM").format(DateTime.parse(d)))
          .join(", ");
    } catch (e) {
      return "";
    }
  }

  Widget _buildBookingList(List<UpcomingEvent> bookings) {
    return ListView.separated(
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final b = bookings[index];
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.network(
                  "${Constants.baseUrl}/${b.coverImageUrl ?? ""}",
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFFFFBFB), Color(0xFFFDF8F8)],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      b.eventName ?? "",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "Booking Amount",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Text(
                        //   b.amount,
                        //   style: TextStyle(
                        //     fontSize: 15,
                        //     fontWeight: FontWeight.w600,
                        //     color: const Color(0xFFE53935),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            formatEventDates(b.eventDate),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),

                        const Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          b.showStartTime ?? "",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Row(
                    //   children: [
                    //     const Icon(
                    //       Icons.location_on_outlined,
                    //       size: 16,
                    //       color: Colors.grey,
                    //     ),
                    //     const SizedBox(width: 6),
                    //     Text(
                    //       b.eventPlace ?? "",
                    //       style: TextStyle(
                    //         fontSize: 14,
                    //         color: Colors.grey.shade600,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String text) {
    return Center(
      child: Text(
        text,
        style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
      ),
    );
  }
}
