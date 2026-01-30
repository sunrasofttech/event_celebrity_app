part of 'add_gallery_images_cubit.dart';

sealed class AddGalleryImagesState extends Equatable {
  const AddGalleryImagesState();
}

final class AddGalleryImagesInitial extends AddGalleryImagesState {
  @override
  List<Object> get props => [];
}

final class AddGalleryImagesLoadedState extends AddGalleryImagesState {
  @override
  List<Object> get props => [];
}

final class AddGalleryImagesLoadingState extends AddGalleryImagesState {
  @override
  List<Object> get props => [];
}

final class AddGalleryImagesErrorState extends AddGalleryImagesState {
  final String error;
  AddGalleryImagesErrorState(this.error);
  @override
  List<Object> get props => [error];
}
