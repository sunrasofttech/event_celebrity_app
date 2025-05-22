import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:mobi_user/UI/MainScreen.dart';
import 'package:mobi_user/Utility/MainColor.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'WelcomeScreen.dart';

class SelectLanguageScreen extends StatefulWidget {
  const SelectLanguageScreen({super.key, this.fromDrawer = false});
  final bool fromDrawer;
  @override
  State<SelectLanguageScreen> createState() => _SelectLanguageScreenState();
}

class _SelectLanguageScreenState extends State<SelectLanguageScreen> {
  final List<String> languages = ['English', 'Hindi', 'Marathi', 'Punjabi', "Gujarati", 'Kannada', 'Tamil', 'Telugu', 'Bengali'];
  String selectedLanguage = 'English';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locale = LocalizedApp.of(context).delegate.currentLocale;

      setState(() {
        switch (locale.languageCode) {
          case 'hi':
            selectedLanguage = 'Hindi';
            break;
          case 'mr':
            selectedLanguage = 'Marathi';
            break;
          case 'pa':
            selectedLanguage = 'Punjabi';
            break;
          case 'gu':
            selectedLanguage = 'Gujarati';
            break;
          case 'kn':
            selectedLanguage = 'Kannada';
            break;
          case 'ta':
            selectedLanguage = 'Tamil';
            break;
          case 'te':
            selectedLanguage = 'Telugu';
            break;
          case 'bn':
            selectedLanguage = 'Bengali';
            break;
          default:
            selectedLanguage = 'English';
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Scaffold(
      backgroundColor: Color(0xFFF5F8FD), // Light background color
      body: Container(
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage("asset/icons/splash_bg.png"))),
        child: SafeArea(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text('Select Language', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: primaryColor)),
                SizedBox(height: 20),
                GridView.builder(
                  itemCount: languages.length,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 2.7,
                  ),
                  itemBuilder: (context, index) {
                    final lang = languages[index];
                    final isSelected = lang == selectedLanguage;

                    return GestureDetector(
                      onTap: () async {
                        setState(() {
                          selectedLanguage = lang;
                        });

                        String localeCode = 'en_US'; // default
                        switch (index) {
                          case 0:
                            localeCode = 'en_US';
                            break;
                          case 1:
                            localeCode = 'hi_IN';
                            break;
                          case 2:
                            localeCode = 'mr_IN';
                            break;
                          case 3:
                            localeCode = 'pa_IN';
                            break;
                          case 4:
                            localeCode = 'gu_IN';
                            break;
                          case 5:
                            localeCode = 'kn_IN';
                            break;
                          case 6:
                            localeCode = 'ta_IN';
                            break;
                          case 7:
                            localeCode = 'te_IN';
                            break;
                          case 8:
                            localeCode = 'bn_IN';
                            break;
                        }

                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('selected_locale', localeCode);

                        await changeLocale(context, localeCode);
                        // setState(() {
                        //   selectedLanguage = lang;
                        // });
                        //
                        // // Change locale using flutter_translate
                        // switch (index) {
                        //   case 0:
                        //     await changeLocale(context, 'en_US');
                        //     break;
                        //   case 1:
                        //     await changeLocale(context, 'hi_IN');
                        //     break;
                        //   case 2:
                        //     await changeLocale(context, 'mr_IN');
                        //     break;
                        //   case 3:
                        //     await changeLocale(context, 'pa_IN');
                        //     break;
                        //   case 4:
                        //     await changeLocale(context, 'gu_IN');
                        //     break;
                        //   case 5:
                        //     await changeLocale(context, 'kn_IN');
                        //     break;
                        //   case 6:
                        //     await changeLocale(context, 'ta_IN');
                        //     break;
                        //   case 7:
                        //     await changeLocale(context, 'te_IN');
                        //     break;
                        //   case 8:
                        //     await changeLocale(context, 'bn_IN');
                        //     break;
                        // }

                        print("--------{localizationDelegate.currentLocale.languageCode}----> ${localizationDelegate.currentLocale.languageCode}");
                        print(translate('next'));
                        setState(() {});
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange : const Color(0xFFF3F6FA),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 10, offset: const Offset(4, 4)),
                            BoxShadow(color: Colors.white, blurRadius: 10, offset: const Offset(-4, -4)),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            lang,
                            style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.white : Colors.grey.shade700, fontSize: 16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Login Button
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // You can navigate to the next screen or save preference here
                      if (widget.fromDrawer == true) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => MainScreen()), (c) => false);
                        // Navigator.pop(context);
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => GetStartedScreen()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(translate('next'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: whiteColor)),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
