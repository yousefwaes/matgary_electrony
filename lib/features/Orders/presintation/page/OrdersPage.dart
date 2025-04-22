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


  OrdersPage({super.key});


  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> with TickerProviderStateMixin {

  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  int selectedTabIndex = 0;
  late TabController _tabController;
  final List<String> orderStatuses = ['الكل', 'قيد المعالجة', 'تم التسليم', 'تم الإلغاء'];
  String searchQuery = "";
  Widget OrdersWidget = Container();

  ScreenUtil screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: orderStatuses.length, vsync: this);
    _tabController.addListener(() {
      setState(() {
        selectedTabIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is OrdersInitial) {
              BlocProvider.of<Orders_bloc>(context)
                  .add(GetAllOrders(id: "0512345678"));
              return _buildLoadingState();
            }

            if (state is OrdersLoading) {
              return _buildLoadingState();
            }

            if (state is OrdersILoaded) {
              if (state.ordersModel.isEmpty) {
                return _buildEmptyState();
              }
              
              return _buildOrdersList(state);
            }
            
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 70, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    "حدث خطأ ما، يرجى المحاولة مرة أخرى",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<Orders_bloc>(context)
                          .add(GetAllOrders(id: "0512345678"));
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text("إعادة المحاولة"),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            'assets/json/loading.json',
            width: screenUtil.screenWidth * 0.5,
            height: screenUtil.screenHeight * 0.3,
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              "جاري تحميل الطلبيات...",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
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
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "لا توجد طلبيات حتى الآن",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "قم بإضافة منتجات إلى السلة وإتمام عملية الشراء",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildOrdersList(OrdersILoaded state) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.grey[50]!, Colors.grey[100]!],
        ),
      ),
      child: Column(
        children: [
          // Stats Card
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard(
                  "إجمالي الطلبيات",
                  "${state.ordersModel.length}",
                  Icons.shopping_bag_outlined,
                  Colors.blue,
                ),
                _buildStatCard(
                  "قيد المعالجة",
                  "${state.ordersModel.where((order) => order.status == 'قيد المعالجة').length}",
                  Icons.pending_outlined,
                  Colors.orange,
                ),
                _buildStatCard(
                  "مكتملة",
                  "${state.ordersModel.where((order) => order.status == 'تم التسليم').length}",
                  Icons.check_circle_outline,
                  Colors.green,
                ),
              ],
            ),
          ),
          
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: TextField(
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: "البحث عن طلبية...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
              ),
            ),
          ),
          
          // Tabs
          Container(
            margin: EdgeInsets.only(top: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorWeight: 3,
              tabs: orderStatuses.map((status) => Tab(text: status)).toList(),
            ),
          ),
          
          // Orders List
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: orderStatuses.map((status) {
                final filteredOrders = status == 'الكل'
                    ? state.ordersModel
                    : state.ordersModel.where((order) => order.status == status).toList();
                
                final searchedOrders = searchQuery.isEmpty
                    ? filteredOrders
                    : filteredOrders.where((order) => 
                        order.id.toString().contains(searchQuery) ||
                        order.customerName.toString().contains(searchQuery) ||
                        order.customerPhone.toString().contains(searchQuery)
                      ).toList();
                
                if (searchedOrders.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 50, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          "لا توجد طلبيات مطابقة للبحث",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<Orders_bloc>(context)
                        .add(GetAllOrders(id: "0512345678"));
                  },
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    itemCount: searchedOrders.length,
                    itemBuilder: (context, index) {
                      final order = searchedOrders[index];
                      return Hero(
                        tag: 'order_${order.id}',
                        child: OrderCard(
                          order: order,
                          onTap: () {
                            // Navigate to order details
                          },
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}