import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/AppTheme.dart';
import '../../../../core/common.dart';
import '../../../../core/util/ScreenUtil.dart';
import '../../../../dataProviders/network/data_source_url.dart';
import '../../../../injection_container.dart';
import '../../../Home/presintation/Widget/BottomNavigation.dart';
import '../../../Home/presintation/Widget/my_app_bar.dart';
import '../../../Product/data/model/ProductModel.dart';
import '../../../ProductDeatils/presintation/page/ProductDeatilsPage.dart';
import '../manager/Cart_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<ProductModel> _cartProducts = [];
  int quantity = 1;
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();
  int itemisselected = 0;
  String valueInput = "";
  Widget CartWidget = Container();
  late ScreenUtil screenUtil;

  @override
  void initState() {
    super.initState();
    _isCart();
    screenUtil = ScreenUtil();
  }

  Future<void> _isCart() async {
    final cart = await getCachedData(
          key: "Cart",
          retrievedDataType: ProductModel.init(),
          returnType: List,
        ) ??
        [];

    if (mounted) {
      setState(() {
        _cartProducts = List<ProductModel>.from(cart);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return Scaffold(
      extendBody: true,
      appBar: myAppBar(context, "السلة"),
      bottomNavigationBar: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Bottomnavigation(),
      ),
      body: BlocProvider(
        create: (context) => sl<Cart_bloc>(),
        child: BlocConsumer<Cart_bloc, CartState>(
          listener: (context, state) {
            if (state is CartError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errorMessage)),
              );
            }
          },
          builder: (context, state) {
            if (state is CartInitial) {
              BlocProvider.of<Cart_bloc>(context).add(Cart());
              return Center(
                child: Lottie.asset('assets/json/loading.json'),
              );
            }

            if (state is CartLoading) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenUtil.screenHeight * .1),
                  const Center(child: Text("جاري التحميل..."))
                ],
              );
            }

            if (state is CartILoaded) {
              return state.productModel.isEmpty
                  ? const Center(child: Text("السلة فارغة"))
                  : Column(children: [
                  Expanded(flex: 8,child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.productModel.length,
                    itemBuilder: (context, index) {
                      final product = state.productModel[index];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDeatilsPage(
                                  id: product.id.toString()),
                            ),
                          );
                        },
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // أيقونة الحذف
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () async {
                                  List<ProductModel> cartItems =
                                      await getCachedData(
                                        key: "Cart",
                                        retrievedDataType:
                                        ProductModel.init(),
                                        returnType: List,
                                      ) ??
                                          [];

                                  cartItems.removeWhere(
                                          (item) => item.id == product.id);
                                  await cachedData(
                                    key: 'Cart',
                                    data: cartItems,
                                  );
                                  BlocProvider.of<Cart_bloc>(context).add(Cart());
                                },
                              ),
                              SizedBox(width: 8),
                              // الاسم والوصف والتقييم والسعر
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      product.name.toString(),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: 2),
                                    if (product.description != null)
                                      Text(
                                        product.description.toString(),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        // السعر
                                        Text(
                                          product.price.toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: primaryColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 2),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.end,
                                      children: [
                                        // عداد الكمية (تم نقله إلى اليسار)
                                        Container(
                                          padding: EdgeInsets.zero,
                                          constraints: BoxConstraints(),
                                          height: 35,
                                          width: 120,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.grey
                                                    .withOpacity(0.3)),
                                            borderRadius:
                                            BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.remove,
                                                    size: 18),
                                                onPressed: () {
                                                  setState(() {
                                                    if (quantity > 1)
                                                      quantity--;
                                                  });
                                                },
                                              ),
                                              Text(
                                                quantity.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight:
                                                  FontWeight.bold,
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.add,
                                                    size: 18),
                                                onPressed: () {
                                                  setState(() {
                                                    quantity++;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 60),
                                        Text(
                                          product.rating.toString(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        Icon(Icons.star,
                                            color: Colors.amber, size: 18),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 15),
                              // الصورة (تم نقلها إلى أقصى اليسار)
                              Container(
                                height: 100,
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                        DataSourceURL.baseImage+product.image.toString()),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // الاسم والوصف والتقييم
                      );
                    },
                  ),),
                Expanded(
                  flex: 3,
                  child: Directionality(textDirection: TextDirection.rtl, child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "الإجمالي: ",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "${state.productModel.fold<double>(0.0, (sum, item) => sum + (double.tryParse(item.price.toString() ?? '0') ?? 0)).toStringAsFixed(2)} ريال",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  )),
                )

              ],);
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
