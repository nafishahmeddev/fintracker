import 'package:currency_picker/currency_picker.dart';
import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/helpers/color.helper.dart';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/theme/colors.dart';
import 'package:fintracker/widgets/buttons/button.dart';
import 'package:fintracker/widgets/dialog/confirm.modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:settings_ui/settings_ui.dart';
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
        body: SettingsList(
          platform: DevicePlatform.android,
          darkTheme: const SettingsThemeData(
            settingsListBackground: Colors.transparent,
            settingsSectionBackground: Colors.transparent
          ),
          lightTheme: const SettingsThemeData(
              settingsListBackground: Colors.transparent,
              settingsSectionBackground: Colors.transparent
          ),
          sections: [
            SettingsSection(
              title: const Text('Common'),
              tiles: <SettingsTile>[
                SettingsTile.navigation(
                  onPressed: (context){
                    showCurrencyPicker(context: context, onSelect: (Currency currency){
                      context.read<AppCubit>().updateCurrency(currency.code);
                    });
                  },
                  leading: const Icon(Icons.currency_exchange),
                  title: const Text('Currency'),
                  value: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                    Currency? currency = CurrencyService().findByCode(state.currency!);
                    return Text(currency!.name);
                  }),
                ),

                SettingsTile.navigation(
                  onPressed: (context){
                    showDialog(context: context, builder: (context){
                      TextEditingController controller = TextEditingController(text: context.read<AppCubit>().state.username);
                      return AlertDialog(
                        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("What should we call you?", style: theme.textTheme.bodyLarge!.apply(color: ColorHelper.darken(theme.textTheme.bodyLarge!.color!), fontWeightDelta: 1),),
                            const SizedBox(height: 15,),
                            TextFormField(
                              controller: controller,
                              decoration: InputDecoration(
                                label: const Text("Name"),
                                  hintText: "Enter your name",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15)
                              ),
                            )
                          ],
                        ),
                        actions: [
                          Row(
                            children: [
                              Expanded(
                                  child: AppButton(
                                    onPressed: (){
                                      if(controller.text.isEmpty){
                                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter name")));
                                      } else {
                                        context.read<AppCubit>().updateUsername(controller.text);
                                        Navigator.of(context).pop();
                                      }
                                    },
                                    height: 45,
                                    label: "Save",
                                  )
                              )
                            ],
                          )
                        ],
                      );
                    });
                  },
                  leading: const Icon(Icons.account_circle),
                  title: const Text('Name'),
                  value: BlocBuilder<AppCubit, AppState>(builder: (context, state) {
                    return Text(state.username!);
                  }),
                ),

                SettingsTile.navigation(
                  onPressed: (context) async {
                    ConfirmModal.showConfirmDialog(
                        context, title: "Are you sure?",
                        content: const Text("After deleting data can't be recovered"),
                        onConfirm: ()async{
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          await context.read<AppCubit>().reset();
                          await resetDatabase();
                        },
                        onCancel: (){
                          Navigator.of(context).pop();
                        }
                    );
                  },
                  leading: const Icon(Icons.delete, color: ThemeColors.error,),
                  title: const Text('Reset'),
                  value: const Text("Delete all the data"),
                ),
              ],
            ),
          ],
        )
    );
  }
}
