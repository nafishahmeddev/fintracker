import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/helpers/color.helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileWidget extends StatelessWidget{
  final VoidCallback onGetStarted;
  const ProfileWidget({super.key, required this.onGetStarted});


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    AppCubit cubit = context.read<AppCubit>();
    TextEditingController controller = TextEditingController(text: cubit.state.username);
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.account_balance_wallet, size: 70,),
              const SizedBox(height: 25,),
              Text("Hi! welcome to Fintracker", style: theme.textTheme.headlineMedium!.apply(color: theme.colorScheme.primary, fontWeightDelta: 1),),
              const SizedBox(height: 15,),
              Text("What should we call you?", style: theme.textTheme.bodyLarge!.apply(color: ColorHelper.darken(theme.textTheme.bodyLarge!.color!), fontWeightDelta: 1),),
              const SizedBox(height: 25,),
              TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                  prefixIcon: const Icon(Icons.account_circle),
                  hintText: "Enter your name",
                  label: const Text("Name")
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          if(controller.text.isEmpty){
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter your name")));
          } else {
            cubit.updateUsername(controller.text).then((value){
              onGetStarted();
            });
          }
        },
        label: const Row(
          children: <Widget>[Text("Next"), SizedBox(width: 10,), Icon(Icons.arrow_forward)],
        ),
      ),
    );
  }

}