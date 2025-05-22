import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:mobi_user/UI/ChangePassScreen.dart';
import 'package:mobi_user/Utility/CustomFont.dart';

import '../Utility/MainColor.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile Details"),
      ),
      body: Column(
        children: [
          BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
            builder: (context, state) {
              if (state is UserProfileFetchedState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                  child: ListTile(
                    leading: state.user.data?.imagePath?.isEmpty ?? true
                        ? CircleAvatar(
                            child: Icon(Icons.person, color: blackColor),
                          )
                        : CircleAvatar(
                            backgroundImage: NetworkImage(state.user.data?.imagePath ?? ""),
                          ),
                    title: Text("${state.user.data?.name}", style: blackStyle),
                  ),
                );
              }
              return Container();
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              readOnly: true,
              decoration: InputDecoration(
                hintText: "Change Password",
                hintStyle: blackStyle,
                prefixIcon: const Icon(Icons.lock, color: blackColor),
                contentPadding: const EdgeInsets.all(10),
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: maroonColor),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.0, 1.0),
                          end: Offset.zero,
                        ).animate(CurvedAnimation(parent: animation, curve: Curves.bounceIn)),
                        child: const ChangePassScreen(),
                      );
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
