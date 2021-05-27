import 'package:flamer/utils/title_updater/title_updater_impl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flamer/screens/splash_screen.dart';
import 'package:flamer/utils/dark_theme_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();

}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  @override
  void initState() {
    super.initState();
    getCurrentAppTheme();
  }

  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
    await DarkThemeProvider.darkThemePreference.getTheme();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Container();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return ChangeNotifierProvider.value(
            value: themeChangeProvider,
            child: Consumer<DarkThemeProvider>(
                builder: (BuildContext context, value, Widget? child) {
                  ThemeMode actualMode = DarkThemeProvider.themeMode(themeChangeProvider.darkTheme);
                  TitleUpdater().updateTitleBar(actualMode);
                  return MaterialApp(
                      title: 'Flamer',
                      themeMode: actualMode,
                      theme: ThemeData(
                        primarySwatch: Colors.deepOrange,
                        floatingActionButtonTheme: FloatingActionButtonThemeData(
                          backgroundColor: Colors.pink.shade900,
                          foregroundColor: Colors.white,
                        ),
                        appBarTheme: AppBarTheme(
                          backgroundColor: Colors.pink.shade900,
                          brightness: Brightness.dark,
                        ),
                        iconTheme: IconThemeData(
                          color: Colors.grey,
                        ),
                      ),
                      darkTheme: ThemeData(
                          brightness: Brightness.dark,
                          iconTheme: IconThemeData(
                            color: Colors.grey.shade400,
                          ),
                          primarySwatch: Colors.deepOrange,
                          accentColor: Colors.deepOrange.shade200,
                          selectedRowColor: Colors.deepOrange.shade200,
                          canvasColor: Color.alphaBlend(Colors.black87, Colors.grey),
                          appBarTheme: AppBarTheme(
                              backgroundColor: Color.alphaBlend(Colors.black87, Colors.white),
                              iconTheme: IconThemeData(color: Colors.grey.shade400)
                          ),
                          tabBarTheme: TabBarTheme(
                              labelColor: Colors.grey.shade400
                          ),
                          primaryTextTheme: Theme.of(context).primaryTextTheme.apply(
                            bodyColor: Colors.grey.shade400,
                            displayColor: Colors.grey.shade400,
                          ),
                          textTheme: Theme.of(context).textTheme.apply(
                            bodyColor: Colors.grey.shade400,
                            displayColor: Colors.grey.shade400,
                          ),
                          shadowColor: Colors.white10,
                          dialogBackgroundColor: Color.alphaBlend(Colors.black87, Colors.white),
                          toggleableActiveColor: Colors.deepOrange.shade200,
                          floatingActionButtonTheme: FloatingActionButtonThemeData(
                            backgroundColor: Colors.deepOrange.shade200,
                            foregroundColor: Colors.black,
                          ),
                          textButtonTheme: TextButtonThemeData(
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(Colors.deepOrange.shade200),
                              )
                          ),
                          checkboxTheme: CheckboxThemeData(
                            checkColor: MaterialStateProperty.all(Colors.black),
                          )
                      ),
                      home: SplashScreen()
                  );
                }
            ),
          );
        }
        return Container();
        // Otherwise, show something whilst waiting for initialization to complete
      },
    );
  }
}
