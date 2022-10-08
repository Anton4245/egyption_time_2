import 'package:ejyption_time_2/core/lib_color_schemes_g2.dart';
import 'package:ejyption_time_2/core/global_model.dart';
import 'package:ejyption_time_2/models/meeting.dart';
import 'package:ejyption_time_2/screens/Meeting_cover_over_detailed.dart';
import 'package:ejyption_time_2/screens/home_page.dart';
import 'package:ejyption_time_2/features/list_of_meeting/meeting_list_provider.dart';
import 'package:ejyption_time_2/screens/participants_selection_cover.dart';
import 'package:flutter/material.dart';
//import 'package:intl/intl_browser.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
//import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  // ignore: unused_local_variable
  GlobalModel gm = GlobalModel.instance;
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(MeetingAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    GlobalModel.instance.commonContext = context;
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
        // localizationsDelegates: context.localizationDelegates,
        // supportedLocales: context.supportedLocales,
        // locale: context.locale,
        theme: prepareLightThemeData(context),
        darkTheme: prepareDarkThemeData(context),
        routes: {
          MeetingCoverOverDetailed.routeName: (ctx) =>
              const MeetingCoverOverDetailed(),
          ParticipantsWidgetCover.routeName: (ctx) =>
              const ParticipantsWidgetCover(),
        },
        locale: const Locale('en'),
        supportedLocales: const [Locale('en'), Locale('ru')],
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
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
