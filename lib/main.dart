import 'package:dynamic_color/dynamic_color.dart';
import 'package:fintracker/helpers/db.helper.dart';
import 'package:fintracker/screens//main.screen.dart';
import 'package:fintracker/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getDBInstance();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDarkMode?  Brightness.light: Brightness.dark
    ));

    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
          ColorScheme scheme = ColorScheme.fromSeed(seedColor: ThemeColors.primary, brightness: MediaQuery.of(context).platformBrightness);
          if(isDarkMode && darkDynamic !=null){
            scheme = darkDynamic.harmonized();
          }
          if(!isDarkMode && lightDynamic !=null){
            scheme = lightDynamic.harmonized();
          }

          return MaterialApp(
            title: 'Fintracker',
            theme: ThemeData(
              colorScheme: scheme,
              useMaterial3: true,
              brightness: MediaQuery.of(context).platformBrightness,
              textTheme: GoogleFonts.rubikTextTheme(
                isDarkMode? ThemeData.dark().textTheme: ThemeData.light().textTheme,
              ),
              navigationBarTheme: NavigationBarThemeData(
                labelTextStyle: MaterialStateProperty.resolveWith((Set<MaterialState> states){
                  TextStyle style =  TextStyle(fontWeight: FontWeight.w500, fontSize: 12, fontFamily: GoogleFonts.rubik().fontFamily);
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
            debugShowCheckedModeBanner: false,
          );
        }
    );
  }
}

