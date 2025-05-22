import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/BidSelectorBloc/BidSelectorEvent.dart';
import 'package:mobi_user/Bloc/BidSelectorBloc/BidSelectorState.dart';

class BidSelectorBloc extends Bloc<BidSelectorEvent, BidSelectorState> {
  BidSelectorBloc() : super(BidSelectorInitState()) {
    on<SelectEvent>((event, emit) {
      try {
        emit(BidSelectorLoadingState());
        switch (event.marketType) {
          case "sd":
            emit(SingleDigitState());
            break;
          case "jd":
            emit(JodiDigitState());
            break;
          case "sp":
            emit(SinglePanaState());
            break;
          case "dp":
            emit(DoublePanaState());
            break;
          case "tp":
            emit(TriplePanaState());
            break;
          case "hsd":
            emit(HalfSangamState());
            break;
          case "fsd":
            emit(FullSangamState());
            break;
        }
      } catch (e) {
        emit(BidSelectorInitState());
        throw Exception(e);
      }
    });
  }
}
