import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planner_celebrity/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:planner_celebrity/Utility/CustomFont.dart';
import 'package:planner_celebrity/Utility/const.dart';
import 'package:planner_celebrity/Widget/ButtonWidget.dart';

import '../Bloc/EditProfileBloc/EditProfileBloc.dart';
import '../Bloc/EditProfileBloc/EditProfileEvent.dart';
import '../Bloc/EditProfileBloc/EditProfileState.dart';
import '../Utility/MainColor.dart';
import '../main.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  TextEditingController _username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();

  File? imageFile;
  String imageUrl = "";
  ImagePicker imagePicker = ImagePicker();

  pickImage(ImageSource source) async {
    final picker = await imagePicker.pickImage(source: source);
    setState(() {
      if (picker != null) {
        imageFile = File(picker.path).absolute;
      }
    });
    Navigator.pop(context);
    return imageFile;
  }

  @override
  void initState() {
    debugPrint("User id:- ${pref.getString("key")}");
    context.read<UserProfileBlocBloc>().add(GetUserProfileEvent());
    _username = TextEditingController();
    email = TextEditingController();
    phone = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _username.dispose();
    email.dispose();
    phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text("My Profile")),
      body: BlocListener<UserProfileBlocBloc, UserProfileBlocState>(
        listener: (context, state) {
          if (state is UserProfileFetchedState) {
            debugPrint("this is image Path ${state.user.data?.imagePath.toString()}");
            setState(() {
              imageUrl = "${Constants.baseUrl}${state.user.data?.imagePath.toString() ?? " "}";
              _username.text = state.user.data?.name.toString() ?? "";
              phone.text = state.user.data?.mobile.toString() ?? "";
            });
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              /* Padding(
                padding: const EdgeInsets.all(15.0),
                child: imageFile == null
                    ? CachedNetworkImage(
                        width: 150,
                        height: 150,
                        imageUrl: imageUrl,
                        errorWidget: (context, _, child) {
                          return CircleAvatar(
                            maxRadius: 80,
                            backgroundImage: const AssetImage("asset/icons/user.png"),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Card(
                                margin: const EdgeInsets.all(5),
                                shape: const CircleBorder(),
                                child: IconButton(
                                  iconSize: 20,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Pick a Photo"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  pickImage(ImageSource.camera);
                                                },
                                                leading: Icon(Icons.camera_alt),
                                                title: Text("Camera"),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  pickImage(ImageSource.gallery);
                                                },
                                                leading: Icon(Icons.photo),
                                                title: Text("Gallery"),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.camera_alt, color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        },
                        imageBuilder: (context, image) {
                          return CircleAvatar(
                            maxRadius: 80,
                            backgroundImage: image,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: Card(
                                margin: const EdgeInsets.all(5),
                                shape: const CircleBorder(),
                                child: IconButton(
                                  iconSize: 20,
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: Text("Pick a Photo"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ListTile(
                                                onTap: () {
                                                  pickImage(ImageSource.camera);
                                                },
                                                leading: Icon(Icons.camera_alt),
                                                title: Text("Camera"),
                                              ),
                                              ListTile(
                                                onTap: () {
                                                  pickImage(ImageSource.gallery);
                                                },
                                                leading: Icon(Icons.photo),
                                                title: Text("Gallery"),
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  icon: const Icon(Icons.camera_alt, color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : CircleAvatar(
                        maxRadius: 80,
                        backgroundImage: FileImage(File(imageFile!.path)),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Card(
                            margin: const EdgeInsets.all(5),
                            shape: const CircleBorder(),
                            child: IconButton(
                              iconSize: 20,
                              onPressed: () {
                                setState(() {
                                  imageFile = null;
                                });
                              },
                              icon: const Icon(Icons.delete_forever, color: Colors.black),
                            ),
                          ),
                        ),
                      ),
              ),*/
              SizedBox(height: 30),
              CircleAvatar(maxRadius: 60, child: Icon(Icons.person, size: 50)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _username,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: blackColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: blackColor),
                    ),
                  ),
                  validator: (val) {},
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: email,
              //     keyboardType: TextInputType.emailAddress,
              //     decoration: InputDecoration(
              //       labelText: "Email",
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: const BorderSide(color: blackColor),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: const BorderSide(color: blackColor),
              //       ),
              //     ),
              //     validator: (val) {},
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: TextFormField(
              //     controller: phone,
              //     validator: (val) {},
              //     maxLength: 10,
              //     keyboardType: TextInputType.phone,
              //     decoration: InputDecoration(
              //       counterText: "",
              //       hintText: "Mobile No",
              //       prefixIcon: const Icon(Icons.call, color: blackColor),
              //       border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: const BorderSide(color: blackColor),
              //       ),
              //       focusedBorder: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(12),
              //         borderSide: const BorderSide(color: blackColor),
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BlocConsumer<EditProfileBloc, EditProfileState>(
                  listener: (context, state) {
                    if (state is LoadedState) {
                      Fluttertoast.showToast(msg: "Profile Update Successfully");
                      Navigator.pop(context);
                    } else if (state is ErrorState) {
                      Fluttertoast.showToast(msg: state.error);
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadingState) {
                      return Center(
                        child: Container(
                          decoration: const BoxDecoration(color: redColor, shape: BoxShape.circle),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: CircularProgressIndicator(color: whiteColor),
                          ),
                        ),
                      );
                    }
                    return ButtonWidget(
                      primaryColor: primaryColor,
                      callback: () {
                        context.read<EditProfileBloc>().add(
                          LoadedEvent(
                            _username.text,
                            email.text,
                            phone.text,
                            imageFile == null ? File("") : File(imageFile!.path),
                          ),
                        );
                      },
                      title: Text("Submit", style: whiteStyle),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
