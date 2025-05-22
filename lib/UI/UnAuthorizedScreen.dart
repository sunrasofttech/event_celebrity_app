import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketCubit.dart';
import 'package:mobi_user/Bloc/MarketBloc/MarketState.dart';

import '../Utility/CustomFont.dart';
import '../Utility/MainColor.dart';

class UnAuthorizedScreen extends StatefulWidget {
  const UnAuthorizedScreen({super.key});

  @override
  State<UnAuthorizedScreen> createState() => _UnAuthorizedScreenState();
}

class _UnAuthorizedScreenState extends State<UnAuthorizedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MarketCubit, MarketState>(
      builder: (context, state) {
        if (state is MarketUnAuthorizedState) {
          print("------------------------__--UNAUTHORIZED ---------------------");
          return SizedBox(
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: false,
              itemCount: state.model.data?.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${state.model.data?[index].marketName}",
                                style: blackStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${state.model.data?[index].result}",
                                style: blueStyle.copyWith(
                                  fontSize: 14,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          crossAxisAlignment: WrapCrossAlignment.end,
                          children: [
                            Text(
                              state.model.data?[index].marketStatusToday.toString() == "close"
                                  ? "Closed for Today"
                                  : state.model.data?[index].marketStatus == "OPEN"
                                  ? "Betting is Running"
                                  : "Closed for Today",
                              style:
                                  state.model.data?[index].marketStatusToday.toString() == "close"
                                      ? redStyle.copyWith(fontSize: 11)
                                      : state.model.data?[index].marketStatus == "OPEN"
                                      ? greenStyle.copyWith(fontSize: 11)
                                      : redStyle.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
        return Container();
      },
    );
  }
}
