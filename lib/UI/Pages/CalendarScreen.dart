import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:planner_celebrity/Bloc/avaibility/get_avalibility/get_avalibility_cubit.dart';
import 'package:planner_celebrity/Bloc/avaibility/get_avalibility/get_avalibility_model.dart';
import 'package:planner_celebrity/Bloc/avaibility/set_ava/set_availbilty_cubit.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// class CalendarScreen extends StatefulWidget {
//   const CalendarScreen({super.key});

//   @override
//   State<CalendarScreen> createState() => _CalendarScreenState();
// }

// class _CalendarScreenState extends State<CalendarScreen> {
//   final TextEditingController _detailsController = TextEditingController();
//   bool _isAutofillDone = false;

//  Set<DateTime> availableDates = {};
// Set<DateTime> unavailableDates = {};
// Set<DateTime> bookedDates = {};

// Set<DateTime> selectedDates = {};

// CalendarView _view = CalendarView.month;
// DateTime _focusedMonth = DateTime(2026, 1, 1);

//   bool _isSameDate(DateTime a, DateTime b) {
//   return a.year == b.year && a.month == b.month && a.day == b.day;
// }

//   final List<DateTime> _unavailableDates = [
//     DateTime(2025, 9, 30),
//     DateTime(2025, 10, 13),
//     DateTime(2025, 10, 21),
//     DateTime(2025, 10, 30),
//     DateTime(2025, 11, 1),
//     DateTime(2025, 11, 3),
//   ];
//   List<Datum> availabilityList = [];
//   Set<DateTime> selectedDates = {};

//   CalendarView _view = CalendarView.month;

//   bool _isBooked(DateTime date) {
//     return _bookedDates.any(
//       (d) => d.year == date.year && d.month == date.month && d.day == date.day,
//     );
//   }

//   bool _isUnavailable(DateTime date) {
//     return _unavailableDates.any(
//       (d) => d.year == date.year && d.month == date.month && d.day == date.day,
//     );
//   }

//   List<String> _formatDatesForApi(Set<DateTime> dates) {
//     return dates
//         .map(
//           (date) =>
//               "${date.year.toString().padLeft(4, '0')}-"
//               "${date.month.toString().padLeft(2, '0')}-"
//               "${date.day.toString().padLeft(2, '0')}",
//         )
//         .toList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: BlocBuilder<GetAvalibilityCubit, GetAvalibilityState>(
//           builder: (context, state) {
//             if(state is GetAvalibilityErrorState){
//               return InkWell(
//                 onTap: () {
//                   context.read<GetAvalibilityCubit>().GetAvailability();
//                 },
//                 child: Center(child: Text("${state.error}"),));
//             }
//             if (state is GetAvalibilityLoadedState) {
//               if (!_isAutofillDone) {
//                 availabilityList = state.model.data ?? [];

//                 for (final item in availabilityList) {
//                   if (item.status == "available" && item.date != null) {
//                     selectedDates.add(DateUtils.dateOnly(item.date!));
//                   }
//                 }

//                 _isAutofillDone = true;
//               }
//               return Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // ------------ HEADER ------------
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 16,
//                       vertical: 12,
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: IconButton(
//                             icon: const Icon(
//                               IconsaxPlusBold.arrow_left_3,
//                               color: greyColor,
//                             ),
//                             onPressed: () => Navigator.pop(context),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           "Update Availability Dates",
//                           style: GoogleFonts.inter(
//                             fontSize: 20,
//                             fontWeight: FontWeight.w700,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // ------------ FORM FIELDS ------------
//                   Expanded(
//                     child: SingleChildScrollView(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           /*const SizedBox(height: 12),
//                             Text("Booking Details", style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600)),
//                             const SizedBox(height: 8),
//                             Container(
//                               decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
//                               child: TextField(
//                                 controller: _detailsController,
//                                 maxLines: 4,
//                                 style: GoogleFonts.inter(fontSize: 15),
//                                 decoration: InputDecoration(
//                                   hintText: "Information",
//                                   hintStyle: GoogleFonts.inter(color: Colors.grey),
//                                   border: InputBorder.none,
//                                   contentPadding: const EdgeInsets.all(16),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 20),*/

//                           // ------------ MONTH SELECTOR ------------
//                           Text(
//                             "Available Dates",
//                             style: GoogleFonts.inter(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           const SizedBox(height: 8),

//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 12),
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                               border: Border.all(color: Colors.grey.shade300),
//                             ),
//                             child: DropdownButtonHideUnderline(
//                               child: DropdownButton<String>(
//                                 value: DateFormat(
//                                   'MMMM yyyy',
//                                 ).format(_selectedDate),
//                                 items:
//                                     [
//                                           'January 2026',
//                                           'November 2026',
//                                           'December 2026',
//                                         ]
//                                         .map(
//                                           (e) => DropdownMenuItem(
//                                             value: e,
//                                             child: Text(e),
//                                           ),
//                                         )
//                                         .toList(),
//                                 onChanged: (value) {},
//                               ),
//                             ),
//                           ),

//                           const SizedBox(height: 16),

//                           // ------------ CALENDAR GRID ------------
//                           Container(
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: SfCalendar(
//                               view: _view,
//                               showNavigationArrow: false,
//                               selectionDecoration: BoxDecoration(
//                                 color: const Color(0xFF339DFF),
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                               backgroundColor: Colors.white,
//                               todayHighlightColor: Colors.transparent,
//                               cellBorderColor: Colors.transparent,
//                               initialDisplayDate: DateTime(2025, 10, 1),
//                               headerStyle: CalendarHeaderStyle(
//                                 textAlign: TextAlign.center,
//                                 textStyle: GoogleFonts.inter(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.black,
//                                 ),
//                               ),

//                               viewHeaderStyle: ViewHeaderStyle(
//                                 dayTextStyle: GoogleFonts.inter(
//                                   color: Colors.grey.shade600,
//                                   fontSize: 13,
//                                   fontWeight: FontWeight.w500,
//                                 ),
//                               ),
//                               monthViewSettings: MonthViewSettings(
//                                 showTrailingAndLeadingDates: true,
//                                 numberOfWeeksInView: 6,
//                                 dayFormat: 'EEE',
//                                 appointmentDisplayMode:
//                                     MonthAppointmentDisplayMode.none,
//                                 monthCellStyle: MonthCellStyle(
//                                   textStyle: GoogleFonts.inter(
//                                     fontSize: 15,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                   leadingDatesTextStyle: GoogleFonts.inter(
//                                     fontSize: 15,
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                   trailingDatesTextStyle: GoogleFonts.inter(
//                                     fontSize: 15,
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                               ),
//                               onSelectionChanged: (details) {
//                                 setState(() {
//                                   _selectedDate = details.date!;
//                                 });
//                               },
//                               monthCellBuilder: (context, details) {
//                                 final date = details.date;
//                                 final isSelected = DateUtils.isSameDay(
//                                   date,
//                                   _selectedDate,
//                                 );
//                                 final isBooked = _isBooked(date);
//                                 final isUnavailable = _isUnavailable(date);

//                                 Color bgColor = Colors.white;
//                                 Color textColor = Colors.black;

//                                 if (isBooked) {
//                                   bgColor = const Color(0xFFFFC0CB);
//                                   textColor = Colors.white;
//                                 } else if (isUnavailable) {
//                                   bgColor = Colors.grey.shade300;
//                                   textColor = Colors.grey.shade600;
//                                 } else if (isSelected) {
//                                   bgColor = const Color(0xFF339DFF);
//                                   textColor = Colors.white;
//                                 }

//                                 return Container(
//                                   margin: const EdgeInsets.all(4),
//                                   decoration: BoxDecoration(
//                                     color: bgColor,
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   alignment: Alignment.center,
//                                   child: Text(
//                                     '${date.day}',
//                                     style: GoogleFonts.inter(
//                                       fontWeight: FontWeight.w600,
//                                       color: textColor,
//                                       fontSize: 15,
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           const SizedBox(height: 16),

//                           // ------------ LEGEND ------------
//                           SingleChildScrollView(
//                             scrollDirection: Axis.horizontal,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 _legendBox(
//                                   "Selected",
//                                   const Color(0xFF339DFF),
//                                   Colors.white,
//                                 ),
//                                 _legendBox(
//                                   "Not available",
//                                   Colors.grey.shade300,
//                                   Colors.black54,
//                                 ),
//                                 _legendBox(
//                                   "Booked",
//                                   const Color(0xFFFFC0CB),
//                                   Colors.black,
//                                 ),
//                                 _legendBox(
//                                   "Available",
//                                   Colors.white,
//                                   Colors.black,
//                                 ),
//                               ],
//                             ),
//                           ),

//                           const SizedBox(height: 24),
//                         ],
//                       ),
//                     ),
//                   ),

//                   // ------------ BOTTOM BUTTON ------------
//                   GestureDetector(
//                     onTap: () {
//                       final formattedDates = _formatDatesForApi(selectedDates);
//                       context.read<SetAvailbiltyCubit>().setAvailability(
//                         formattedDates,
//                         "available",
//                       );
//                     },
//                     child: Container(
//                       width: double.infinity,
//                       margin: const EdgeInsets.all(16),
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Center(
//                         child: Text(
//                           "Save and Update",
//                           style: GoogleFonts.inter(
//                             color: Colors.white,
//                             fontSize: 14,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             }
//             return SizedBox();
//           },
//         ),
//       ),
//     );
//   }

//   Widget _legendBox(String text, Color color, Color textColor) {
//     return Container(
//       margin: const EdgeInsets.only(right: 6),
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       decoration: BoxDecoration(
//         color: color,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: Colors.grey.shade300),
//       ),
//       child: Text(
//         text,
//         style: GoogleFonts.inter(color: textColor, fontWeight: FontWeight.w500),
//       ),
//     );
//   }
// }

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  Set<DateTime> availableDates = {};
  Set<DateTime> unavailableDates = {};
  Set<DateTime> bookedDates = {};
  Set<DateTime> selectedDates = {};
  bool _isInitialized = false;

  bool _isAutofillDone = false;
  CalendarView _view = CalendarView.month;
  late DateTime _focusedMonth;

  DateTime _parse(String date) => DateUtils.dateOnly(DateTime.parse(date));

  @override
  void initState() {
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GetAvalibilityCubit, GetAvalibilityState>(
          buildWhen: (previous, current) {
            return current is GetAvalibilityLoadedState;
          },
          builder: (context, state) {
            if (state is GetAvalibilityLoadingState) {
              return Center(child: CircularProgressIndicator());
            }
            if (state is GetAvalibilityErrorState) {
              return Center(
                child: InkWell(
                  onTap:
                      () =>
                          context.read<GetAvalibilityCubit>().GetAvailability(),
                  child: Text(state.error),
                ),
              );
            }

            if (state is GetAvalibilityLoadedState) {
              final data = state.model.data!;
              log("trigredede");

              if (!_isInitialized) {
                availableDates =
                    (data.availableDates ?? []).map((e) => _parse(e)).toSet();

                unavailableDates =
                    (data.unavailableDates ?? []).map((e) => _parse(e)).toSet();

                bookedDates =
                    (data.bookedDates ?? []).map((e) => _parse(e)).toSet();

                _isInitialized = true;
              }

              return Column(
                children: [
                  /// ---------- HEADER ----------
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Update Availability Dates",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// ---------- CALENDAR ----------
                  Expanded(
                    child: SfCalendar(
                      view: _view,
                      initialDisplayDate: _focusedMonth,
                      todayHighlightColor: Colors.transparent,
                      cellBorderColor: Colors.transparent,
                      showNavigationArrow: true,

                      onSelectionChanged: (calendarSelectionDetails) {
                        log("--- 11111");
                      },
                      onViewChanged: (ViewChangedDetails details) {
                        final middleIndex = details.visibleDates.length ~/ 2;
                        final visibleDate = details.visibleDates[middleIndex];

                        final int year = visibleDate.year;
                        final int month = visibleDate.month;

                        if (_focusedMonth.year != year ||
                            _focusedMonth.month != month) {
                          _focusedMonth = DateTime(year, month);
                          _isInitialized = false;

                          context.read<GetAvalibilityCubit>().GetAvailability(
                            year: year,
                            month: month,
                          );
                        }
                      },

                      // onViewChanged: (ViewChangedDetails details) {
                      //   log("--------------- 11");
                      //   final visibleDate = details.visibleDates.first;

                      //   final int year = visibleDate.year;
                      //   final int month = visibleDate.month;

                      //   if (_focusedMonth.year != year ||
                      //       _focusedMonth.month != month) {
                      //     _focusedMonth = DateTime(year, month);

                      //     context.read<GetAvalibilityCubit>().GetAvailability(
                      //       year: year,
                      //       month: month,
                      //     );
                      //   }
                      // },
                      onTap: (details) {
                        final date = DateUtils.dateOnly(details.date!);
                        log("------ onTap Trigreed");
                        if (bookedDates.contains(date)) return;
                        setState(() {
                          if (availableDates.contains(date)) {
                            log("------ onTap availableDates $availableDates");
                            // AVAILABLE → UNAVAILABLE
                            availableDates.remove(date);
                            unavailableDates.add(date);
                            selectedDates.add(date);
                          } else if (unavailableDates.contains(date)) {
                            log(
                              "------ onTap unavailableDates $unavailableDates",
                            );
                            // UNAVAILABLE → AVAILABLE
                            unavailableDates.remove(date);
                            availableDates.add(date);
                            selectedDates.add(date);
                          } else {
                            // 🆕 NEW DATE → AVAILABLE
                            availableDates.add(date);
                            selectedDates.add(date);
                          }
                        });
                      },

                      monthCellBuilder: (context, details) {
                        final date = DateUtils.dateOnly(details.date);

                        Color bg = Colors.white;
                        Color text = Colors.black;

                        if (bookedDates.contains(date)) {
                          bg = Colors.pink.shade300;
                          text = Colors.white;
                        } else if (unavailableDates.contains(date)) {
                          bg = Colors.grey.shade300;
                          text = Colors.grey.shade700;
                        } else if (availableDates.contains(date)) {
                          bg = Colors.white;
                        }

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            log("CELL TAPPED: $date");

                            if (bookedDates.contains(date)) return;

                            setState(() {
                              if (availableDates.contains(date)) {
                                availableDates.remove(date);
                                unavailableDates.add(date);
                              } else if (unavailableDates.contains(date)) {
                                unavailableDates.remove(date);
                                availableDates.add(date);
                              } else {
                                availableDates.add(date);
                              }

                              selectedDates.add(date);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: bg,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color:
                                    selectedDates.contains(date)
                                        ? Colors.blue
                                        : Colors.grey.shade300,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              date.day.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: text,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  /// ---------- LEGEND ----------
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _legend("Available", Colors.white),
                        _legend("Unavailable", Colors.grey.shade300),
                        _legend("Booked", Colors.pink.shade300),
                      ],
                    ),
                  ),

                  /// ---------- SAVE BUTTON ----------
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: BlocListener<SetAvailbiltyCubit, SetAvailbiltyState>(
                      listener: (context, state) {
                        if (state is SetAvailbiltyErrorState) {
                          Fluttertoast.showToast(msg: "${state.error}");
                        }
                        if (state is SetAvailbiltyLoadedState) {
                          Fluttertoast.showToast(msg: "Update Successfully");
                        }
                      },
                      child: GestureDetector(
                        onTap: _onSave,
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Save & Update",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  /// ---------- SAVE API ----------
  void _onSave() {
    final unavailable =
        selectedDates
            .where((d) => unavailableDates.contains(d))
            .map(_format)
            .toList();

    final available =
        selectedDates
            .where((d) => availableDates.contains(d))
            .map(_format)
            .toList();

    if (unavailable.isNotEmpty) {
      context.read<SetAvailbiltyCubit>().setAvailability(
        unavailable,
        "unavailable",
      );
    }

    if (available.isNotEmpty) {
      context.read<SetAvailbiltyCubit>().setAvailability(
        available,
        "available",
      );
    }
  }

  String _format(DateTime d) =>
      "${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}";

  Widget _legend(String text, Color color) {
    return Row(
      children: [
        Container(
          height: 14,
          width: 14,
          decoration: BoxDecoration(
            color: color,
            border: Border.all(color: Colors.grey),
          ),
        ),
        const SizedBox(width: 6),
        Text(text),
      ],
    );
  }
}
