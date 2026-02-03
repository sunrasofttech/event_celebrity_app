part of 'share_feedback_cubit.dart';

sealed class ShareFeedbackState extends Equatable {
  const ShareFeedbackState();
}

final class ShareFeedbackInitialState extends ShareFeedbackState {
  @override
  List<Object> get props => [];
}

final class ShareFeedbackLoadingState extends ShareFeedbackState {
  @override
  List<Object> get props => [];
}

final class ShareFeedbackLoadedState extends ShareFeedbackState {
  @override
  List<Object> get props => [];
}

final class ShareFeedbackErrorState extends ShareFeedbackState {
  final String error;
  ShareFeedbackErrorState(this.error);
  @override
  List<Object> get props => [error];
}
