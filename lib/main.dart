import 'package:flamer/utils/title_updater/title_updater_impl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flamer/screens/splash_screen.dart';
import 'package:flamer/utils/dark_theme_preference.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

/// Empieza el programa lanzando la app.
main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

/// Widget que engloba el estado de toda la aplicación.
class App extends StatefulWidget {

  /// Crea el estado para el Widget de la app.
  @override
  _AppState createState() => _AppState();
}

/// Estado del widget [App]
class _AppState extends State<App> {

  /// Prooveedor del tema actual de la aplicación
  DarkThemeProvider themeChangeProvider = new DarkThemeProvider();

  /// Establece los valores iniciales del estado.
  @override
  void initState() {
    super.initState();
    /// Obtiene el tema seleccionado de la aplicación sea automática o no.
    getCurrentAppTheme();
  }

  /// Inicializa el proveedor de temas y lo establece en [DarkThemeProvider.darkThemePreference]
  void getCurrentAppTheme() async {
    themeChangeProvider.darkTheme =
      await DarkThemeProvider.darkThemePreference.getTheme();
  }

  /// Constructor del widget [App] para el [context] seleccionado.
  @override
  Widget build(BuildContext context) {
    /// Constructor en base a la promesa de inicializar el acceso a la instancia
    /// de Firebase.
    return FutureBuilder(
      /// Se inicializa Firebase
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        /// Se devuelve un contenedor con el error al no conectar con Firebase.
        if (snapshot.hasError) {
          return Container();
        }

        /// Una vez completada la conexión, mostrar el contenido de la
        /// aplicación.
        if (snapshot.connectionState == ConnectionState.done) {
          /// Se consultan cambios en el proveedor de temas para establecerlo
          /// conforme al perfil seleccionado.
          return ChangeNotifierProvider.value(
            value: themeChangeProvider,
            child: Consumer<DarkThemeProvider>(
                /// Constructor de la aplicación en base al tema.
                builder: (BuildContext context, value, Widget? child) {
                  /// Actualización del tema seleccionado al renderizar.
                  ThemeMode actualMode = DarkThemeProvider.themeMode(themeChangeProvider.darkTheme);
                  TitleUpdater().updateTitleBar(actualMode);
                  /// Devuelve la App estilo Material.
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
        /// Si no hay conexión dejar un contenedor vacío mientras carga.
        return Container();
      },
    );
  }
}
