
import 'package:equatable/equatable.dart';



abstract class WinHistoryEvent extends Equatable {}

class FetchWinHistoryDataEvent extends WinHistoryEvent {
  final String page;
  final String sDate;
  final String eDate;


  FetchWinHistoryDataEvent({required this.page,required this.eDate,required this.sDate});
  @override
  // TODO: implement props
  List<Object?> get props => [page,sDate,eDate];
}
