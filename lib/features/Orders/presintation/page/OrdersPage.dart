import 'package:aamarpay/aamarpay.dart';
import 'package:flutter/material.dart';
import '../../../../core/util/ScreenUtil.dart';
import '../../../Home/presintation/Widget/BottomNavigation.dart';
import '../../../Home/presintation/Widget/my_app_bar.dart';


class Orders extends StatefulWidget {
  final String id;

  Orders({super.key, required this.id});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  int itemisselected = 0;
  String valueInput = "";
  Widget ProductWidget = Container();

  ScreenUtil screenUtil = ScreenUtil();

  Widget build(BuildContext context) {
    screenUtil.init(context);
    bool isLoading = false;
    return Scaffold(
      appBar: myAppBar(context, "المنتجات"),
      bottomNavigationBar: Bottomnavigation(),





    );
  }
}
