import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final TextEditingController _detailsController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  final List<DateTime> _bookedDates = [
    DateTime(2025, 10, 9),
    DateTime(2025, 10, 16),
    DateTime(2025, 10, 17),
    DateTime(2025, 10, 23),
  ];

  final List<DateTime> _unavailableDates = [
    DateTime(2025, 9, 30),
    DateTime(2025, 10, 13),
    DateTime(2025, 10, 21),
    DateTime(2025, 10, 30),
    DateTime(2025, 11, 1),
    DateTime(2025, 11, 3),
  ];

  CalendarView _view = CalendarView.month;

  bool _isBooked(DateTime date) {
    return _bookedDates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day);
  }

  bool _isUnavailable(DateTime date) {
    return _unavailableDates.any((d) => d.year == date.year && d.month == date.month && d.day == date.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ------------ HEADER ------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                    child: IconButton(
                      icon: const Icon(IconsaxPlusBold.arrow_left_3, color: greyColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Update Availability Dates",
                    style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),

            // ------------ FORM FIELDS ------------
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*const SizedBox(height: 12),
                    Text("Booking Details", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: TextField(
                        controller: _detailsController,
                        maxLines: 4,
                        style: GoogleFonts.inter(fontSize: 15),
                        decoration: InputDecoration(
                          hintText: "Information",
                          hintStyle: GoogleFonts.inter(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),*/

                    // ------------ MONTH SELECTOR ------------
                    Text("Available Dates", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: DateFormat('MMMM yyyy').format(_selectedDate),
                          items:
                              [
                               'January 2026',
                                'November 2026',
                                'December 2026',
                                
                              ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (value) {},
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ------------ CALENDAR GRID ------------
                    Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      child: SfCalendar(
                        view: _view,
                        showNavigationArrow: false,
                        selectionDecoration: BoxDecoration(
                          color: const Color(0xFF339DFF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: Colors.white,
                        todayHighlightColor: Colors.transparent,
                        cellBorderColor: Colors.transparent,
                        initialDisplayDate: DateTime(2025, 10, 1),
                        headerStyle: CalendarHeaderStyle(
                          textAlign: TextAlign.center,
                          textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
                        ),

                        viewHeaderStyle: ViewHeaderStyle(
                          dayTextStyle: GoogleFonts.inter(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        monthViewSettings: MonthViewSettings(
                          showTrailingAndLeadingDates: true,
                          numberOfWeeksInView: 6,
                          dayFormat: 'EEE',
                          appointmentDisplayMode: MonthAppointmentDisplayMode.none,
                          monthCellStyle: MonthCellStyle(
                            textStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
                            leadingDatesTextStyle: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                            trailingDatesTextStyle: GoogleFonts.inter(
                              fontSize: 15,
                              color: Colors.grey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        onSelectionChanged: (details) {
                          setState(() {
                            _selectedDate = details.date!;
                          });
                        },
                        monthCellBuilder: (context, details) {
                          final date = details.date;
                          final isSelected = DateUtils.isSameDay(date, _selectedDate);
                          final isBooked = _isBooked(date);
                          final isUnavailable = _isUnavailable(date);

                          Color bgColor = Colors.white;
                          Color textColor = Colors.black;

                          if (isBooked) {
                            bgColor = const Color(0xFFFFC0CB);
                            textColor = Colors.white;
                          } else if (isUnavailable) {
                            bgColor = Colors.grey.shade300;
                            textColor = Colors.grey.shade600;
                          } else if (isSelected) {
                            bgColor = const Color(0xFF339DFF);
                            textColor = Colors.white;
                          }

                          return Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
                            alignment: Alignment.center,
                            child: Text(
                              '${date.day}',
                              style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: textColor, fontSize: 15),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // ------------ LEGEND ------------
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _legendBox("Selected", const Color(0xFF339DFF), Colors.white),
                          _legendBox("Not available", Colors.grey.shade300, Colors.black54),
                          _legendBox("Booked", const Color(0xFFFFC0CB), Colors.black),
                          _legendBox("Available", Colors.white, Colors.black),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ------------ BOTTOM BUTTON ------------
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(16)),
              child: Center(
                child: Text(
                  "Save and Update",
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _legendBox(String text, Color color, Color textColor) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(text, style: GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w500)),
    );
  }
}
