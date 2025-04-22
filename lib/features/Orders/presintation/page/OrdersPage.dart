import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart'; // استيراد حزمة lottie
import '../../../../core/util/ScreenUtil.dart';
import '../../../../injection_container.dart';
import '../../../Home/presintation/Widget/BottomNavigation.dart';
import '../../../Home/presintation/Widget/my_app_bar.dart';
import '../manager/Orders_bloc.dart';
import '../Widget/OrderCard.dart';


class OrdersPage extends StatefulWidget {
  final String id;

  OrdersPage({super.key, required this.id});


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
      appBar: myAppBar(context, "الطلبيات"),
      bottomNavigationBar: Bottomnavigation(),
      body: BlocProvider(
        create: (context) => sl<Orders_bloc>(),
        child: BlocConsumer<Orders_bloc, OrdersState>(
          listener: (context, state) {
            if (state is OrdersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.red,
                ),
              );
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/json/loading.json',
                      width: screenUtil.screenWidth * 0.5,
                      height: screenUtil.screenHeight * 0.3,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "جاري تحميل الطلبيات...",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              );
            }

            if (state is OrdersILoaded) {
              if (state.ordersModel.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/json/empty.json',
                        width: screenUtil.screenWidth * 0.6,
                        height: screenUtil.screenHeight * 0.3,
                        repeat: false,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "لا توجد طلبيات حتى الآن",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "قم بإضافة منتجات إلى السلة وإتمام عملية الشراء",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              
              return Container(
                color: Colors.grey[100],
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "عدد الطلبيات: ${state.ordersModel.length}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: () async {
                          BlocProvider.of<Orders_bloc>(context)
                              .add(GetAllOrders(id: widget.id.toString()));
                        },
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: state.ordersModel.length,
                          itemBuilder: (context, index) {
                            final order = state.ordersModel[index];
                            return OrderCard(
                              order: order,
                              onTap: () {
                                // Navigate to order details
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            
            return const Center(
              child: Text("حدث خطأ ما، يرجى المحاولة مرة أخرى"),
            );
          },
        ),
      ),
    );
  }
}