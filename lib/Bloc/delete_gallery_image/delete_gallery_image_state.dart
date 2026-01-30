part of 'delete_gallery_image_cubit.dart';

sealed class DeleteGalleryImageState extends Equatable {}

final class DeleteGalleryImageInitial extends DeleteGalleryImageState {
  @override
  List<Object?> get props => [];
}

final class DeleteGalleryImageLoadingState extends DeleteGalleryImageState {
  @override
  List<Object?> get props => [];
}


final class DeleteGalleryImageLoadedState extends DeleteGalleryImageState {
  @override
  List<Object?> get props => [];
}


final class DeleteGalleryImageErrorState extends DeleteGalleryImageState {
  final String error;
  DeleteGalleryImageErrorState(this.error);
  @override
  List<Object?> get props => [error];
}
