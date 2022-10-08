import 'package:ejyption_time_2/core/lib_color_schemes_g2.dart';
import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/screens/Meeting_cover_over_detailed.dart';
import 'package:ejyption_time_2/screens/home_page.dart';
import 'package:ejyption_time_2/features/list_of_meeting/meeting_list_provider.dart';
import 'package:ejyption_time_2/screens/participants_selection_cover.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await findSystemLocale();
  // ignore: unused_local_variable
  GlobalModel gm = GlobalModel.instance;

  await Hive.initFlutter();
  Hive.registerAdapter(HiveBookingAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<Meetings>(
            create: (_) => Meetings(GlobalModel.instance.meetingList)),
        // FutureProvider<List<User>>(
        //   initialData: [],
        //   create: (_) async => UserProvider().loadUserData(),
        // ),
        // StreamProvider<int>(
        //   initialData: 0,
        //   create: (_) => EventProvider().intStream(),
        // ),
      ],
      child: MaterialApp(
        title: 'Egyption time 2',
        theme: prepareLightThemeData(context),
        darkTheme: prepareDarkThemeData(context),
        routes: {
          MeetingCoverOverDetailed.routeName: (ctx) =>
              const MeetingCoverOverDetailed(),
          ParticipantsWidgetCover.routeName: (ctx) =>
              const ParticipantsWidgetCover(),
        },
        localizationsDelegates: const [
          //AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''), // English, no country code
          Locale('ru', ''), // Spanish, no country code
        ],
        home: const HomePage2(),
      ),
    );
  }

  ThemeData prepareLightThemeData(BuildContext context) {
    ThemeData theme = ThemeData(
      useMaterial3: false,
      colorScheme: lightColorScheme,
      textTheme: prepareTextStyle(),
    );

    return theme;
  }

  ThemeData prepareDarkThemeData(BuildContext context) {
    var theme = ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      textTheme: prepareTextStyle(),
    );

    return theme;
  }

  TextTheme prepareTextStyle() {
    return TextTheme(
      headline6: TextStyle(
        fontSize: 18,
        fontStyle: FontStyle.italic,
        //fontWeight: FontWeight.bold,
        color: lightColorScheme.primary,
      ),
      headline5: TextStyle(
          fontSize: 18,
          fontStyle: FontStyle.italic,
          //fontWeight: FontWeight.bold,
          color: lightColorScheme.onBackground),
      subtitle1: const TextStyle(
        fontWeight: FontWeight.normal,
      ),
      subtitle2: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          color: lightColorScheme.onBackground.withAlpha(0x99)),
      bodyText1: const TextStyle(fontWeight: FontWeight.normal),
      bodyText2:
          TextStyle(color: lightColorScheme.onBackground.withAlpha(0x99)),
    );
  }
}
