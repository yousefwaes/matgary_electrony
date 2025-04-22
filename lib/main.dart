import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/Cart/presintation/manager/Cart_bloc.dart';
import 'features/Favorite/presintation/page/FavoritePage.dart';
import 'features/Home/presintation/page/HomePage.dart';
import 'features/Cart/presintation/page/CartPage.dart';
import 'features/Orders/presintation/page/OrdersPage.dart';
import 'injection_container.dart' as object;

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // تأكد من التهيئة هنا
  await object.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/home': (context) => HomePage(),
        '/favorite' :(context) => FavoritePage(),
         '/cart' :(context) => CartPage(),
        '/reports' :(context) => Orders(id: '',),
      },

    );
  }
}

