import 'package:equatable/equatable.dart';

abstract class SuggestionListEvent extends Equatable{}
class SuggestionListInitEvent extends SuggestionListEvent{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class SuggestionListLoadEvent extends SuggestionListEvent{
  final String type;
  final String digit;
  SuggestionListLoadEvent({required this.type,required this.digit});
  @override
  // TODO: implement props
  List<Object?> get props => [type];
}
class SuggestionListHSDEvent extends SuggestionListEvent{
  final String type;
  SuggestionListHSDEvent({required this.type});
  @override
  // TODO: implement props
  List<Object?> get props => [type];
}