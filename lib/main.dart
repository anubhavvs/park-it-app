import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter/services.dart';

import './screens/areas_overview.dart';
import './screens/area_slot.dart';
import './screens/auth.dart';
import './screens/splash_screen.dart';
import './screens/booking.dart';

import './providers/areas.dart';
import './providers/auth.dart';
import './providers/bookings.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(MyApp()));

  await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

Map<int, Color> color = {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(406, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};

MaterialColor colorCustom = MaterialColor(0xff916DB0, color);
MaterialColor coloCustom = MaterialColor(0xffD5DFF2, color);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProxyProvider<Auth, Areas>(
            create: (_) => Areas(),
            update: (_, auth, areas) => areas..authToken = auth.token),
        ChangeNotifierProxyProvider<Auth, Bookings>(
            create: (_) => Bookings(),
            update: (_, auth, bookings) => bookings..authToken = auth.token)
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                title: 'Park It',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  primarySwatch: colorCustom,
                  // ignore: deprecated_member_use
                  accentColor: Colors.blue[100],
                  fontFamily: 'Acumin Variable Concept',

                  textTheme: TextTheme(
                    bodyText1: TextStyle(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black.withOpacity(0.6),
                      // fontFamily: 'Acumin Variable Concept',
                      letterSpacing: 0.5,
                      wordSpacing: 0.2,
                    ),
                  ),
                ),
                home: auth.isAuth
                    ? auth.active
                        ? BookingScreen()
                        : AreasOverviewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResult) =>
                            authResult.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen()),
                routes: {
                  AreaSlotScreen.routeName: (ctx) => AreaSlotScreen(),
                  BookingScreen.routeName: (ctx) => BookingScreen()
                },
              )),
    );
  }
}
