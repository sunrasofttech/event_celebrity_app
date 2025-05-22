/*
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:tatamatka/Bloc/BidSelectorBloc/BidSelectorBloc.dart';
import 'package:tatamatka/Bloc/BidSelectorBloc/BidSelectorEvent.dart';
import 'package:tatamatka/Bloc/BidSelectorBloc/BidSelectorState.dart';
import 'package:tatamatka/Bloc/MarketBloc/MarketModel.dart';
import 'package:tatamatka/Bloc/SuggestionListBloc/SuggestionListBloc.dart';
import 'package:tatamatka/Bloc/SuggestionListBloc/SuggestionListEvent.dart';
import 'package:tatamatka/Bloc/SuggestionListBloc/SuggestionListState.dart';
import 'package:tatamatka/Utility/CustomFont.dart';
import 'package:tatamatka/Utility/MainColor.dart';

import '../model/gameType.dart';

class MarketDashboardScreen extends StatefulWidget {
  final MarketModel market;
  final GameType game;
  final int index;
  final String id;
  final String shortCode;

  const MarketDashboardScreen({Key? key, required this.market, required this.index, required this.game, required this.id, required this.shortCode}) : super(key: key);

  @override
  State<MarketDashboardScreen> createState() => _MarketDashboardScreenState();
}

class _MarketDashboardScreenState extends State<MarketDashboardScreen> {
  @override
  void initState() {
   context.read<BidSelectorBloc>().add(SelectEvent(widget.shortCode));
   context.read<SuggestionListBloc>().add(SuggestionListLoadEvent(type:widget.shortCode));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.market.result[widget.index].name),
      ),
      body: BlocBuilder<BidSelectorBloc,BidSelectorState>(
        builder: (context,state){
          if(state is BidSelectorLoadingState){
            return Center(child: CircularProgressIndicator());
          }
          else if(state is SingleDigitState){
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text("Single Digit",style: blackStyle),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.calendar_month),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(DateFormat("dd/MM/yyyy").format(widget.market.result[widget.index].dt)),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(

                                      decoration: InputDecoration(
                                          hintText: "Select Market",
                                          contentPadding: EdgeInsets.all(15),
                                          border: OutlineInputBorder()
                                      ),
                                      items: ["Open","Close"].map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e))).toList(), onChanged: (val){

                                  }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<SuggestionListBloc,SuggestionListState>(
                      builder: (context,state){
                        if(state is LoadedState){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: state.model.result.length,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2,childAspectRatio: 4),
                                itemBuilder: (context,index){
                                  return TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      prefixIcon: Card(
                                        margin: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(30),
                                            bottomLeft: Radius.circular(30)
                                          )
                                        ),
                                        color: redColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(state.model.result[index].digit,style: whiteStyle),
                                        ),
                                      ),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomLeft: Radius.circular(30)
                                            )
                                        ),
                                    ),
                                  );
                                }),
                          );
                        }
                        else if(state is LoadingState){
                          return Center(child: CircularProgressIndicator());
                        }
                        return Container();
                      }),
                  ElevatedButton(onPressed: (){}, child: Text("Submit"))
                ],
              ),
            );
          }
          else if(state is JodiDigitState){
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text("Jodi Digit",style: blackStyle),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.calendar_month),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(DateFormat("dd/MM/yyyy").format(widget.market.result[widget.index].dt)),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(

                                      decoration: InputDecoration(
                                          hintText: "Select Market",
                                          contentPadding: EdgeInsets.all(15),
                                          border: OutlineInputBorder()
                                      ),
                                      items: ["Open","Close"].map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e))).toList(), onChanged: (val){

                                  }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<SuggestionListBloc,SuggestionListState>(
                      builder: (context,state){
                        if(state is LoadedState){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: state.model.result.length,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2,childAspectRatio: 4),
                                itemBuilder: (context,index){
                                  return TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      prefixIcon: Card(
                                        margin: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomLeft: Radius.circular(30)
                                            )
                                        ),
                                        color: redColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(state.model.result[index].digit,style: whiteStyle),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30)
                                          )
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }
                        else if(state is LoadingState){
                          return Center(child: CircularProgressIndicator());
                        }
                        return Container();
                      }),
                  ElevatedButton(onPressed: (){}, child: Text("Submit"))
                ],
              ),
            );
          }
          else if(state is SinglePanaState){
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text("Single Digit",style: blackStyle),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.calendar_month),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(DateFormat("dd/MM/yyyy").format(widget.market.result[widget.index].dt)),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(

                                      decoration: InputDecoration(
                                          hintText: "Select Market",
                                          contentPadding: EdgeInsets.all(15),
                                          border: OutlineInputBorder()
                                      ),
                                      items: ["Open","Close"].map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e))).toList(), onChanged: (val){

                                  }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<SuggestionListBloc,SuggestionListState>(
                      builder: (context,state){
                        if(state is LoadedState){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: state.model.result.length,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2,childAspectRatio: 4),
                                itemBuilder: (context,index){
                                  return TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      prefixIcon: Card(
                                        margin: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomLeft: Radius.circular(30)
                                            )
                                        ),
                                        color: redColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(state.model.result[index].digit,style: whiteStyle),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30)
                                          )
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }
                        return Container();
                      }),
                  ElevatedButton(onPressed: (){}, child: Text("Submit"))
                ],
              ),
            );
          }
          else if(state is DoublePanaState){
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Card(
                    color: Colors.white,
                    child: Column(
                      children: [
                        Text("Single Digit",style: blackStyle),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.calendar_month),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(DateFormat("dd/MM/yyyy").format(widget.market.result[widget.index].dt)),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButtonFormField(

                                      decoration: InputDecoration(
                                          hintText: "Select Market",
                                          contentPadding: EdgeInsets.all(15),
                                          border: OutlineInputBorder()
                                      ),
                                      items: ["Open","Close"].map((e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e))).toList(), onChanged: (val){

                                  }),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<SuggestionListBloc,SuggestionListState>(
                      builder: (context,state){
                        if(state is LoadedState){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GridView.builder(
                                shrinkWrap: true,
                                itemCount: state.model.result.length,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisSpacing: 20,
                                    mainAxisSpacing: 10,
                                    crossAxisCount: 2,childAspectRatio: 4),
                                itemBuilder: (context,index){
                                  return TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.all(10),
                                      prefixIcon: Card(
                                        margin: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                bottomLeft: Radius.circular(30)
                                            )
                                        ),
                                        color: redColor,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(state.model.result[index].digit,style: whiteStyle),
                                        ),
                                      ),
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(30),
                                              bottomLeft: Radius.circular(30)
                                          )
                                      ),
                                    ),
                                  );
                                }),
                          );
                        }
                        return Container();
                      }),
                  ElevatedButton(onPressed: (){}, child: Text("Submit"))
                ],
              ),
            );
          }

          return Container();
        },
      ),
    );
  }
}
*/
