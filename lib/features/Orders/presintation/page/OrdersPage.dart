import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart'; // استيراد حزمة lottie
import '../../../../core/util/ScreenUtil.dart';
import '../../../../injection_container.dart';
import '../../../Home/presintation/Widget/BottomNavigation.dart';
import '../../../Home/presintation/Widget/my_app_bar.dart';
import '../manager/Orders_bloc.dart';


class OrdersPage extends StatefulWidget {

  OrdersPage({super.key});


  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {

  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  int itemisselected = 0;
  String valueInput = "";
  Widget OrdersWidget = Container();

  ScreenUtil screenUtil = ScreenUtil();

  Widget build(BuildContext context) {

    screenUtil.init(context);

    return Scaffold(
      appBar: myAppBar(context, "المنتجات"),
      bottomNavigationBar: Bottomnavigation(),
      body: BlocProvider(
        create: (context) => sl<Orders_bloc>(),
        child: BlocConsumer<Orders_bloc, OrdersState>(
          listener: (context, state) {
            if (state is OrdersError) {
              print(state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is OrdersInitial) {
              BlocProvider.of<Orders_bloc>(context)
                  .add(GetAllOrders(id: widget.id.toString()));
              return Center(
                child: Lottie.asset('assets/json/loading.json'),
              );
            }

            if (state is OrdersLoading) {
              OrdersWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: screenUtil.screenHeight * .1,
                  ),
                  Center(
                      child: Text("loding ......."))


                ],
              );
            }

            if (state is OrdersILoaded) {
              //TODO::Show Orders here

              return
            }
            return OrdersWidget;
          },
        ),
      ),
    );
  }
}