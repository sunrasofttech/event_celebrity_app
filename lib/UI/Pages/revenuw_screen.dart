import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:intl/intl.dart';
import 'package:planner_celebrity/Bloc/get_all_revenue/get_all_revenue_cubit.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';

class TotalRevenueScreen extends StatefulWidget {
  const TotalRevenueScreen({super.key});

  @override
  State<TotalRevenueScreen> createState() => _TotalRevenueScreenState();
}

class _TotalRevenueScreenState extends State<TotalRevenueScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetAllRevenueCubit>().getAllRevenue();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: blackColor),
        title: Text("Revenue", style: TextStyle(color: blackColor)),
        automaticallyImplyLeading: true,
        backgroundColor: whiteColor,
        actions: [
          GestureDetector(
            onTap: () {
              _openFilterSheet(context);
            },
            child: Icon(IconsaxPlusBold.filter),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: BlocBuilder<GetAllRevenueCubit, GetAllRevenueState>(
        builder: (context, state) {
          if (state is GetAllRevenueLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is GetAllRevenueLoadedState) {
            final data = state.model.data;

            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Total Revenue", style: TextStyle(color: Colors.white70)),
                          Text(
                            "₹ ${data?.summary?.totalRevenue ?? 0}",
                            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text("Transactions", style: TextStyle(color: Colors.white70)),
                          Text(
                            "${data?.summary?.totalTransactions ?? 0}",
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: data?.revenueList?.length ?? 0,
                    itemBuilder: (context, index) {
                      final item = data!.revenueList![index];

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 3)],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// EVENT INFO
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.eventName ?? "",
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  item.userName ?? "Guest",
                                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  formatDate(item.createdAt.toString()),
                                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                                ),
                              ],
                            ),

                            /// AMOUNT
                            Text(
                              "₹ ${item.agreedPrice}",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          }

          if (state is GetAllRevenueErrorState) {
            return Center(child: Text(state.error));
          }

          return const SizedBox();
        },
      ),
    );
  }

  String formatDate(String? date) {
    if (date == null || date.isEmpty) return "";

    DateTime parsed = DateTime.parse(date).toLocal();

    return DateFormat("dd MMM yyyy • hh:mm a").format(parsed);
  }

  void _openFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) {
        DateTime? fromDate;
        DateTime? toDate;

        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  const Text(
                    "Filter Revenue",
                    style: TextStyle(fontFamily: "Inter", fontSize: 16, fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 20),

                  /// Quick Filters
                  _filterOption("Today", () {
                    _applyFilter(filterType: "today");
                    Navigator.pop(context);
                  }),

                  _filterOption("Yesterday", () {
                    _applyFilter(filterType: "yesterday");
                    Navigator.pop(context);
                  }),

                  _filterOption("Tomorrow", () {
                    _applyFilter(filterType: "tomorrow");
                    Navigator.pop(context);
                  }),

                  const SizedBox(height: 20),

                  /// From Date
                  _datePickerTile(
                    label: "From Date",
                    selectedDate: fromDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => fromDate = picked);
                      }
                    },
                  ),

                  const SizedBox(height: 10),

                  /// To Date
                  _datePickerTile(
                    label: "To Date",
                    selectedDate: toDate,
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2020),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => toDate = picked);
                      }
                    },
                  ),

                  const SizedBox(height: 20),

                  SimpleButton(
                    onPressed: () {
                      if (fromDate != null && toDate != null) {
                        _applyFilter(start: fromDate, end: toDate);
                        Navigator.pop(context);
                      }
                    },
                    title: "Apply",
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _filterOption(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontFamily: "Inter", fontSize: 14, fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  Widget _datePickerTile({required String label, required DateTime? selectedDate, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFEDEDED)),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedDate == null ? label : "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
              style: const TextStyle(fontFamily: "Inter", fontSize: 12, fontWeight: FontWeight.w500),
            ),
            const Icon(Icons.calendar_today, size: 18),
          ],
        ),
      ),
    );
  }

  void _applyFilter({String? filterType, DateTime? start, DateTime? end}) {
    context.read<GetAllRevenueCubit>().getAllRevenue(filter: filterType, startDate: start, endDate: end);
  }
}
