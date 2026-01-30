import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:planner_celebrity/Bloc/get_profile/get_profile_cubit.dart';
import 'package:planner_celebrity/Bloc/userProfileBloc/user_profile_bloc_bloc.dart';
import 'package:planner_celebrity/UI/Profile/SettingScreen.dart';
import 'package:planner_celebrity/Utility/const.dart';

class UserModel {
  final String name;
  final String imageUrl;

  UserModel({required this.name, required this.imageUrl});
}

final UserModel user = UserModel(
  name: "Alexandra Davis",
  imageUrl: "https://i.pravatar.cc/150?img=3",
);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // final List<String> galleryImages = [
  //   "https://images.unsplash.com/photo-1507874457470-272b3c8d8ee2",
  //   "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4",
  //   "https://images.unsplash.com/photo-1497032205916-ac775f0649ae",
  //   "https://images.unsplash.com/photo-1511379938547-c1f69419868d",
  //   "https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f",
  //   "https://images.unsplash.com/photo-1511379938547-c1f69419868d",
  // ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<GetProfileCubit>().getProfile();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey.shade100,
          body: SingleChildScrollView(
            child: BlocBuilder<GetProfileCubit, GetProfileState>(
              builder: (context, state) {
                if (state is GetProfileLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is GetProfileLoadedState) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            // stops: [0.0, 0.7404,],
                            colors: [
                              Color(0xFFFFDCDD),
                              Color(0xFFFFDCDD),
                              Color(0xFFF4F4F4),
                            ],
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundImage: NetworkImage(
                                      "${Constants.baseUrl}/${state.model.data?.profilePictureUrl}",
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Flexible(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Welcome",
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Text(
                                          "${state.model.data?.fullName}",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 5),

                            Image.asset("asset/icons/gitar.png", height: 150),
                            SizedBox(width: 10),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SettingScreen(),
                                  ),
                                );
                              },
                              child: Image.asset("asset/icons/setting.png"),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionTitle("Bio"),
                            const SizedBox(height: 8),
                            Text(
                              "${state.model.data?.shortBio}",
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),

                            const SizedBox(height: 24),

                            /// RATE CARD
                            _sectionTitle("Rate Card"),
                            const SizedBox(height: 12),
                            GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount:
                                  state.model.data?.rateCard?.length ?? 0,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1.3,
                                  ),
                              itemBuilder: (context, index) {
                                final item = state.model.data?.rateCard?[index];
                                return RateCard(
                                  title: item?.serviceName ?? "",
                                  price: "₹ ${item?.price ?? ""}",
                                );
                              },
                            ),

                            SizedBox(height: 24),

                            /// SOCIAL MEDIA
                            _sectionTitle("Social Media Handles"),
                            const SizedBox(height: 12),
                            SocialItem(
                              icon: IconsaxPlusBold.hashtag,
                              text:
                                  "${state.model.data?.socialMediaLinks?.twitter}",
                            ),
                            SocialItem(
                              icon: IconsaxPlusBold.instagram,
                              text:
                                  "${state.model.data?.socialMediaLinks?.instagram}",
                            ),

                            /// GALLERY
                            _sectionTitle("GALLERY"),
                            const SizedBox(height: 12),

                            StaggeredGrid.count(
                              crossAxisCount: 2,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              children: List.generate(
                                state.model.data?.galleryImages?.length ?? 0,
                                (index) {
                                  return StaggeredGridTile.fit(
                                    crossAxisCellCount: 1,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: AspectRatio(
                                        // ZIP-ZAP HEIGHT CONTROL
                                        aspectRatio:
                                            index.isEven ? 1 / 1.2 : 1 / 1.6,
                                        child: Image.network(
                                          "${Constants.baseUrl}/${state.model.data?.galleryImages?[index].imageUrl ?? ""}",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.w600,
        fontSize: 13,
        letterSpacing: 0.5,
      ),
    );
  }
}

class RateCard extends StatelessWidget {
  final String title;
  final String price;

  const RateCard({super.key, required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 13)),
          const SizedBox(height: 8),
          Text(
            price,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class SocialItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const SocialItem({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}
