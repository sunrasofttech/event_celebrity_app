import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingCubit.dart';
import 'package:mobi_user/Bloc/SettingBloc/SettingState.dart';

class HarmfulAppsDialog extends StatefulWidget {
  final List<Map<String, String>> appPackageNames;

  const HarmfulAppsDialog({super.key, required this.appPackageNames});

  @override
  State<HarmfulAppsDialog> createState() => _HarmfulAppsDialogState();
}

class _HarmfulAppsDialogState extends State<HarmfulAppsDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingCubit, SettingState>(
      builder: (context, state) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.red.shade600,
              title: Text("Harmful Apps Detected"),
              actions: [IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop())],
            ),
            body: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    (state is SettingLoadedState && state.model.data != null)
                        ? state.model.data![0].harmFullAppTitle ??
                            "The following apps are considered harmful. You can go to settings to uninstall them."
                        : "The following apps are considered harmful. You can go to settings to uninstall them.",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                const Divider(height: 1.2),

                /// List of Apps
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.appPackageNames.length,
                    itemBuilder:
                        (_, index) => ListTile(
                          onTap: () {
                            final intent = AndroidIntent(
                              action: 'android.intent.action.UNINSTALL_PACKAGE',
                              data: 'package:${widget.appPackageNames[index]['package_name']}',
                              flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
                            );
                            intent.launch();
                          },
                          leading:
                              widget.appPackageNames[index]["app_logo"] != null
                                  ? CachedNetworkImage(imageUrl: widget.appPackageNames[index]["app_logo"]!, width: 35, height: 35)
                                  : const Icon(Icons.warning, color: Colors.red),
                          title: Text(widget.appPackageNames[index]["app_name"] ?? ""),
                          subtitle: Text(widget.appPackageNames[index]["app_desc"] ?? ""),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.delete_forever, color: Colors.green),
                              SizedBox(width: 4),
                              Text("Uninstall", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                  ),
                ),

                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text("Close", style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
