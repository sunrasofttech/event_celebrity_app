import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/GameRateBloc/GameRateCubit.dart';
import 'package:mobi_user/Bloc/GameRateBloc/GameRateState.dart';
import 'package:mobi_user/Utility/CustomFont.dart';

class GameRateScreen extends StatefulWidget {
  const GameRateScreen({Key? key}) : super(key: key);

  @override
  State<GameRateScreen> createState() => _GameRateScreenState();
}

class _GameRateScreenState extends State<GameRateScreen> {
  @override
  void initState() {
    context.read<GameRateCubit>().getGameRate();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Game Rates"),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("Main Game Win Ratio for All Bids",
                    style: blackStyle.copyWith(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          BlocBuilder<GameRateCubit, GameRateState>(
            builder: (context, state) {
              if (state is LoadingState) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is LoadedState) {
                return Card(
                  child: Column(
                    children: List.generate(
                      state.model.data?.length ?? 0,
                      (index) => ListTile(
                        title: Text("${state.model.data?[index].name}", style: blackStyle),
                        trailing: Text("${state.model.data?[index].rate}", style: blackStyle),
                      ),
                    ).toList(),
                  ),
                );
              }
              return Container();
            },
          ),
          /* Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text("Starline Game Win Ratio",style: blackStyle.copyWith(fontSize: 16,fontWeight: FontWeight.bold)),

              ],
            ),
          ),
          Card(
            color: blueColor,
           */ /* shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: blueColor)
            ),*/ /*
            child: MyContainer(
              radius: 10,
              child: Column(
                children: [
                  ListTile(
                    title: Text("Single Digit :",style: blackStyle),
                    trailing: Text("10 ka 90",style: blackStyle),
                  ),
                  ListTile(
                    title: Text("Jodi Digit :",style: blackStyle),
                    trailing: Text("10 KA 950",style: blackStyle),
                  ),
                  ListTile(
                    title: Text("Single Panna :",style: blackStyle),
                    trailing: Text("10 KA 1400",style: blackStyle),
                  ),
                  ListTile(
                    title: Text("Double Panna :",style: blackStyle),
                    trailing: Text("10 ka 2800",style: blackStyle),
                  ),
                  ListTile(
                    title: Text("Triple Panna :",style: blackStyle),
                    trailing: Text("10 ka 6000",style: blackStyle),
                  ),

                ],
              ),
            ),
          )*/
        ],
      ),
    );
  }
}
