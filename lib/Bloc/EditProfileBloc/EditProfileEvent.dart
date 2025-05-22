import 'package:equatable/equatable.dart';
import 'dart:io';
abstract class EditProfileEvent extends Equatable{}
class InitialEvent extends EditProfileEvent{
  @override
  List<Object?> get props => [];
}
class LoadedEvent extends EditProfileEvent{
  final String username;
  final String email;
  final String phone;
  final File? imageFile;
  LoadedEvent(this.username,this.email, this.phone,  this.imageFile);
  @override
  List<Object?> get props => [username,phone,email,imageFile];
}

