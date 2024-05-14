import 'package:fintracker/bloc/cubit/app_cubit.dart';
import 'package:fintracker/screens/main.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:month_year_picker/month_year_picker.dart';

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: MediaQuery.of(context).platformBrightness
    ));
    return  BlocBuilder<AppCubit, AppState>(
        builder: (context, state){
          return MaterialApp(
            title: 'Fintracker',
            theme: ThemeData(
                useMaterial3: true,
                brightness: MediaQuery.of(context).platformBrightness,
                navigationBarTheme: NavigationBarThemeData(
                  labelTextStyle: MaterialStateProperty.resolveWith((Set<MaterialState> states){
                    TextStyle style =  const TextStyle(fontWeight: FontWeight.w500, fontSize: 11);
                    if(states.contains(MaterialState.selected)){
                      style = style.merge(const TextStyle(fontWeight: FontWeight.w600));
                    }
                    return style;
                  }),
                )
            ),
            home: const MainScreen(),
            localizationsDelegates: const [
              GlobalWidgetsLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              MonthYearPickerLocalizations.delegate,
            ],
          );
        }
    );
  }
}