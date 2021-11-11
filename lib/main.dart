import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_config/flutter_config.dart';

import './screens/areas_overview.dart';
import './screens/area_slot.dart';
import './screens/auth.dart';
import './screens/splash_screen.dart';
import './screens/booking.dart';

import './providers/areas.dart';
import './providers/auth.dart';
import './providers/bookings.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
  await FlutterConfig.loadEnvVariables();

  runApp(MyApp());
}

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
                theme: ThemeData(
                  primarySwatch: Colors.green,
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
