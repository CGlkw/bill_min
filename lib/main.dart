import 'package:flutter/material.dart';
import 'package:bill/common/Global.dart';
import 'package:bill/routes/Routes.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
//Global.init().then((e) => runApp(MyApp()));

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Global.init().then((e) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context)  {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_)=> ThemeModel()),
      ],

      child: Consumer<ThemeModel>(
        builder: (BuildContext context, themeModel, Widget child){
          return OKToast(
            child: MaterialApp(
              title: 'Bill',
              theme: ThemeData(
                primarySwatch: themeModel.theme,
              ),
              localeListResolutionCallback:
                  (List<Locale> locales, Iterable<Locale> supportedLocales) {
                return Locale('zh');
              },
              localeResolutionCallback:
                  (Locale locale, Iterable<Locale> supportedLocales) {
                return Locale('zh');
              },
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                const Locale('zh', 'CH'),
                const Locale('en', 'US'),
              ],
              locale: Locale('zh'),
              initialRoute: '/',
              routes: Routes(context).init(),
            ),
          );
        },
      ),
    );
  }
}
