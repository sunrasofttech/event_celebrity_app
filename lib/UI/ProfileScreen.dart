// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:planner_celebrity/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
// import 'package:planner_celebrity/Utility/CustomFont.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../Utility/MainColor.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   openWhatsapp(number) async {
//     var whatsapp = number;
//     var whatsappURl_android =
//         "whatsapp://send?phone=" + whatsapp + "&text=Hello Admin! I want to change my password to=";
//     var whatsappURL_ios = "https://wa.me/$whatsapp?text=";
//     if (Platform.isIOS) {
//       // for iOS phone only
//       if (await canLaunchUrl(Uri.parse(whatsappURL_ios))) {
//         await launchUrl(Uri.parse(whatsappURL_ios));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
//       }
//     } else {
//       // android , web
//       if (await canLaunchUrl(Uri.parse(whatsappURl_android))) {
//         await launchUrl((Uri.parse(whatsappURl_android)));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: new Text("whatsapp no installed")));
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Profile Details")),
//       body: Column(
//         children: [
//           BlocBuilder<UserProfileBlocBloc, UserProfileBlocState>(
//             builder: (context, state) {
//               if (state is UserProfileFetchedState) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
//                   child: ListTile(
//                     leading:
//                         state.user.data?.imagePath?.isEmpty ?? true
//                             ? CircleAvatar(child: Icon(Icons.person, color: blackColor))
//                             : CircleAvatar(backgroundImage: NetworkImage(state.user.data?.imagePath ?? "")),
//                     title: Text("${state.user.data?.name}", style: blackStyle),
//                   ),
//                 );
//               }
//               return Container();
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextFormField(
//               readOnly: true,
//               decoration: InputDecoration(
//                 hintText: "Change Password",
//                 hintStyle: blackStyle,
//                 prefixIcon: const Icon(Icons.lock, color: blackColor),
//                 contentPadding: const EdgeInsets.all(10),
//                 border: OutlineInputBorder(
//                   borderSide: const BorderSide(color: playColor),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onTap: () {},
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
