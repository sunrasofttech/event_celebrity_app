import 'package:equatable/equatable.dart';
import 'package:mobi_user/Bloc/BannerBloc/BannerModel.dart';

abstract class BannerState extends Equatable {}

class BannerInitState extends BannerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BannerLoadingState extends BannerState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BannerLoadedState extends BannerState {
  final BannerModel model;
  BannerLoadedState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

class BannerErrorState extends BannerState {
  final String error;
  BannerErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
