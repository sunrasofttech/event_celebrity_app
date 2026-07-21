import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:planner_celebrity/Bloc/Auth/RegisterBloc/RegisterCubit.dart';
import 'package:planner_celebrity/Bloc/Auth/RegisterBloc/RegisterState.dart';
import 'package:planner_celebrity/Bloc/CategoryCubit/CategoryCubit.dart';
import 'package:planner_celebrity/Bloc/CategoryCubit/CategoryState.dart';
import 'package:planner_celebrity/Bloc/CityCubit/CityCubit.dart';
import 'package:planner_celebrity/Bloc/CityCubit/CityState.dart';
import 'package:planner_celebrity/UI/Auth/LoginScreen.dart';
import 'package:planner_celebrity/UI/Auth/VerifyOTPScreen.dart';
import 'package:planner_celebrity/Utility/CustomTextField.dart';
import 'package:planner_celebrity/Utility/MainColor.dart';
import 'package:planner_celebrity/Utility/SimpleButton.dart';
import 'package:planner_celebrity/model/CityModel.dart';
import 'package:planner_celebrity/model/userProfileModel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController publicHandleController = TextEditingController();
  final TextEditingController shortBioController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();

  final TextEditingController rateController = TextEditingController();
  final TextEditingController countController = TextEditingController();

  String? selectedCityId;
  String? selectedCityName;
  List<String> selectedCategories = [];
  List<RateCard> rateCardList = [];

  String? selectedDuration;
  final List<String> durationList = [
    "Day",
    "Hour",
    "Event",
    "Show",
    "Appearance",
  ];

  String? _selectedImagePath;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().fetchCategories();
    context.read<CityCubit>().fetchCities();
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImagePath = image.path;
      });
    }
  }

  Widget _fieldLabel(String title, {bool isRequired = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          text: title,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          children: [
            if (isRequired)
              const TextSpan(
                text: " *",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Register Celebrity Account",
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: BlocConsumer<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is SendOtpSuccess) {
                Fluttertoast.showToast(msg: "OTP sent successfully!");
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => VerifyOTPScreen(
                          mobile: mobileController.text.trim(),
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          fullName: fullNameController.text.trim(),
                          publicHandle: publicHandleController.text.trim(),
                          shortBio: shortBioController.text.trim(),
                          location: selectedCityName ?? "Mumbai",
                          cityId: selectedCityId ?? "",
                          categoryIds: selectedCategories,
                          rateCard: rateCardList,
                          instagramHandle: instagramController.text.trim(),
                          twitterHandle: twitterController.text.trim(),
                          profilePicturePath: _selectedImagePath,
                        ),
                  ),
                );
              }

              if (state is SendOtpError) {
                Fluttertoast.showToast(msg: state.error);
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Profile Picture Picker
                  Center(
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: _pickImage,
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage:
                                    _selectedImagePath != null
                                        ? FileImage(File(_selectedImagePath!))
                                        : null,
                                child:
                                    _selectedImagePath == null
                                        ? const Icon(
                                          IconsaxPlusBold.user,
                                          size: 50,
                                          color: Colors.grey,
                                        )
                                        : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 2,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedImagePath == null
                              ? "Tap to add profile picture *"
                              : "Change profile picture",
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Full Name
                  _fieldLabel("Full Name"),
                  CustomTextField(
                    controller: fullNameController,
                    hintText: "Enter Full Name (e.g. Test Celebrity)",
                    prefixIcon: IconsaxPlusBold.user,
                  ),

                  const SizedBox(height: 16),

                  /// Email
                  _fieldLabel("Email"),
                  CustomTextField(
                    controller: emailController,
                    hintText: "Enter Email Address",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: IconsaxPlusBold.sms,
                  ),

                  const SizedBox(height: 16),

                  /// Mobile Number
                  _fieldLabel("Mobile Number"),
                  CustomTextField(
                    controller: mobileController,
                    hintText: "Enter 10-digit Mobile Number",
                    keyboardType: TextInputType.phone,
                    prefixIcon: IconsaxPlusBold.mobile,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// Password
                  _fieldLabel("Password"),
                  CustomTextField(
                    maxLine: 1,
                    controller: passwordController,
                    hintText: "Enter Password",
                    prefixIcon: IconsaxPlusBold.lock,
                    obscureText: obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? IconsaxPlusBold.eye_slash
                            : IconsaxPlusBold.eye,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => obscurePassword = !obscurePassword);
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Public Handle
                  _fieldLabel("Public Handle"),
                  CustomTextField(
                    controller: publicHandleController,
                    hintText: "Enter Public Handle (e.g. @testceleb)",
                    prefixIcon: IconsaxPlusBold.hashtag,
                  ),

                  const SizedBox(height: 16),

                  /// Short Bio
                  _fieldLabel("Short Bio"),
                  CustomTextField(
                    controller: shortBioController,
                    hintText:
                        "Short Bio (e.g. Live Performance & Stage Artist)",
                    maxLine: 3,
                    prefixIcon: IconsaxPlusBold.document_text,
                  ),

                  const SizedBox(height: 16),

                  /// City Dropdown
                  _fieldLabel("City"),
                  BlocBuilder<CityCubit, CityState>(
                    builder: (context, cityState) {
                      if (cityState is CityLoaded) {
                        final cities = cityState.model.data ?? [];
                        final validId =
                            cities.any((c) => c.id == selectedCityId)
                                ? selectedCityId
                                : null;
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: validId,
                              hint: Text(
                                "Select City",
                                style: GoogleFonts.inter(
                                  color: Colors.grey.shade500,
                                ),
                              ),
                              items:
                                  cities.map((city) {
                                    return DropdownMenuItem<String>(
                                      value: city.id,
                                      child: Text(
                                        city.name ?? '-',
                                        style: GoogleFonts.inter(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (value) {
                                final found = cities.firstWhere(
                                  (c) => c.id == value,
                                  orElse: () => CityDatum(),
                                );
                                setState(() {
                                  selectedCityId = value;
                                  selectedCityName = found.name;
                                });
                              },
                            ),
                          ),
                        );
                      }
                      if (cityState is CityLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Retry loading cities",
                              style: GoogleFonts.inter(color: Colors.grey),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh, size: 20),
                              onPressed:
                                  () => context.read<CityCubit>().fetchCities(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Categories Multi-Select
                  _fieldLabel("Categories"),
                  BlocBuilder<CategoryCubit, CategoryState>(
                    builder: (context, catState) {
                      if (catState is CategoryLoaded) {
                        final categories = catState.model.data ?? [];
                        return Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children:
                              categories.map((cat) {
                                final isSelected = selectedCategories.contains(
                                  cat.id,
                                );
                                return FilterChip(
                                  label: Text(
                                    cat.title?.trim() ?? '',
                                    style: GoogleFonts.inter(
                                      color:
                                          isSelected
                                              ? Colors.white
                                              : Colors.black87,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor: primaryColor,
                                  backgroundColor: Colors.grey.shade100,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        if (cat.id != null)
                                          selectedCategories.add(cat.id!);
                                      } else {
                                        selectedCategories.remove(cat.id);
                                      }
                                    });
                                  },
                                );
                              }).toList(),
                        );
                      }
                      if (catState is CategoryLoading) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Center(
                        child: TextButton.icon(
                          onPressed:
                              () =>
                                  context
                                      .read<CategoryCubit>()
                                      .fetchCategories(),
                          icon: const Icon(Icons.refresh),
                          label: const Text("Retry Categories"),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Social Media Handles
                  _fieldLabel("Social Media Links", isRequired: false),
                  CustomTextField(
                    controller: instagramController,
                    hintText: "Instagram handle (e.g. @janedoe or link)",
                    prefixIcon: IconsaxPlusBold.instagram,
                  ),
                  const SizedBox(height: 10),
                  CustomTextField(
                    controller: twitterController,
                    hintText: "Facebook / Twitter handle (e.g. @janedoe)",
                    prefixIcon: IconsaxPlusBold.link_2,
                  ),

                  const SizedBox(height: 24),

                  /// Rate Card Section
                  _fieldLabel("Rate Card", isRequired: false),
                  Row(
                    children: [
                      // Rate Price
                      Expanded(
                        child: CustomTextField(
                          controller: rateController,
                          hintText: "Rate (e.g. 50000)",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Count
                      Expanded(
                        child: CustomTextField(
                          controller: countController,
                          hintText: "Count (e.g. 1)",
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Duration Dropdown
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedDuration,
                              hint: Text(
                                "Unit",
                                style: GoogleFonts.inter(
                                  color: Colors.grey.shade500,
                                  fontSize: 13,
                                ),
                              ),
                              isExpanded: true,
                              items:
                                  durationList.map((item) {
                                    return DropdownMenuItem(
                                      value: item,
                                      child: Text(
                                        item,
                                        style: GoogleFonts.inter(fontSize: 13),
                                      ),
                                    );
                                  }).toList(),
                              onChanged: (val) {
                                setState(() {
                                  selectedDuration = val;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  SimpleButton(
                    onPressed: () {
                      if (rateController.text.trim().isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter rate price");
                        return;
                      }
                      if (countController.text.trim().isEmpty) {
                        Fluttertoast.showToast(msg: "Please enter count");
                        return;
                      }
                      if (selectedDuration == null) {
                        Fluttertoast.showToast(
                          msg: "Please select unit duration",
                        );
                        return;
                      }

                      setState(() {
                        rateCardList.add(
                          RateCard(
                            serviceName:
                                "${countController.text.trim()} $selectedDuration",
                            price: rateController.text.trim(),
                            description: "Performance service",
                          ),
                        );
                        rateController.clear();
                        countController.clear();
                        selectedDuration = null;
                      });
                    },
                    title: " Add Service to Rate Card ",
                  ),

                  const SizedBox(height: 12),

                  /// Rate Card List view
                  if (rateCardList.isNotEmpty)
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: rateCardList.length,
                      itemBuilder: (context, index) {
                        final item = rateCardList[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "₹ ${item.price} / ${item.serviceName}",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    rateCardList.removeAt(index);
                                  });
                                },
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 30),

                  /// Submit / Send OTP Button
                  SizedBox(
                    width: double.infinity,
                    child:
                        (state is SendOtpLoading)
                            ? const Center(child: CircularProgressIndicator())
                            : SimpleButton(
                              onPressed: () {
                                if (_selectedImagePath == null) {
                                  Fluttertoast.showToast(
                                    msg: "Please select a profile picture",
                                  );
                                  return;
                                }
                                if (fullNameController.text.trim().isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Please enter full name",
                                  );
                                  return;
                                }
                                if (emailController.text.trim().isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Please enter email",
                                  );
                                  return;
                                }
                                if (mobileController.text.trim().length != 10) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Please enter a valid 10-digit mobile number",
                                  );
                                  return;
                                }
                                if (passwordController.text.trim().isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Please enter password",
                                  );
                                  return;
                                }
                                if (publicHandleController.text
                                    .trim()
                                    .isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Please enter public handle",
                                  );
                                  return;
                                }
                                if (shortBioController.text.trim().isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Please enter short bio",
                                  );
                                  return;
                                }
                                if (selectedCityId == null ||
                                    selectedCityId!.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Please select a city",
                                  );
                                  return;
                                }
                                if (selectedCategories.isEmpty) {
                                  Fluttertoast.showToast(
                                    msg: "Please select at least one category",
                                  );
                                  return;
                                }

                                context.read<RegisterCubit>().sendOtp(
                                  mobileController.text.trim(),
                                );
                              },
                              title: "Send OTP & Continue",
                            ),
                  ),

                  const SizedBox(height: 25),

                  /// Already have an account link
                  Center(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: RichText(
                        text: const TextSpan(
                          text: "Already a member? ",
                          style: TextStyle(color: Colors.black45, fontSize: 14),
                          children: [
                            TextSpan(
                              text: "Log In",
                              style: TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
