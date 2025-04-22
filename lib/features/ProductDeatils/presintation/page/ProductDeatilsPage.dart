import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:matgary_electrony/core/AppTheme.dart';
import 'package:matgary_electrony/core/util/ScreenUtil.dart';
import '../../../../core/common.dart';
import '../../../../dataProviders/network/data_source_url.dart';
import '../../../../injection_container.dart';
import '../../../Home/presintation/Widget/BottomNavigation.dart';
import '../../../Home/presintation/Widget/my_app_bar.dart';
import '../../../Product/data/model/ProductModel.dart';
import '../manager/ProductDeatils_bloc.dart';

class ProductDeatilsPage extends StatefulWidget {
  final String id;

  ProductDeatilsPage({super.key, required this.id});

  @override
  State<ProductDeatilsPage> createState() => _ProductDeatilsPageState();
}

class _ProductDeatilsPageState extends State<ProductDeatilsPage> {
  int quantity = 1; // كمية المنتج
  double totalPrice = 0.0; // السعر الإجمالي
  ScrollController _scrollController = ScrollController();

  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();
  int itemisselected = 0;
  String valueInput = "";
  Widget ProductDeatilsWidget = Container();
  ScreenUtil screenUtil = ScreenUtil();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose(); // إغلاق ScrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return Scaffold(
      appBar: myAppBar(context, "بيانات المنتج"),
      body: BlocProvider(
        create: (context) => sl<ProductDeatils_bloc>(),
        child: BlocConsumer<ProductDeatils_bloc, ProductDeatilsState>(
          listener: (context, state) {
            if (state is ProductDeatilsError) {
              print(state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is ProductDeatilsInitial) {
              BlocProvider.of<ProductDeatils_bloc>(context)
                  .add(GetAllProductDeatils(id: widget.id.toString()));
            }

            if (state is ProductDeatilsLoading) {
              ProductDeatilsWidget = Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: screenUtil.screenHeight * .1),
                  Center(
                      child: Text(
                    "جاري التحميل...",
                    style: TextStyle(
                        fontFamily: AppTheme.fontFamily, fontSize: 20),
                  )),
                ],
              );
            }

            if (state is ProductDeatilsILoaded) {
              totalPrice = quantity *
                  double.parse(state.productModel.price.toString());

              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 1,
                    ),
                    // صورة المنتج
                    Container(
                      height: 350,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(45.0),
                          bottomRight: Radius.circular(45.0),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            // لون الظل
                            spreadRadius: 2,
                            // مدى انتشار الظل
                            blurRadius: 5,
                            // درجة ضبابية الظل
                            offset: Offset(0, 3), // موقع الظل
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(DataSourceURL.baseImage+state.productModel.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    // تفاصيل المنتج
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // اسم المنتج وزر المفضلة
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // زر المفضلة
                              IconButton(
                                icon: Icon(Icons.favorite_border,
                                    color: Colors.red),
                                onPressed: () {
                                  // إضافة المنتج إلى المفضلة
                                },
                              ),
                              // اسم المنتج
                              Text(
                                state.productModel.name,
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 2),
                          Row(children: [
                            //السعر االسابق
                            Text(
                              textAlign: TextAlign.start,
                              "السعر السابق: ${state.productModel.oldPrice.toString()} \$",
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.lineThrough,
                                // إضافة خط فوق النص
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            SizedBox(width: 140),
                            // السعر
                            Text(
                              textAlign: TextAlign.end,
                              "السعر: ${state.productModel.price.toString()} \$",
                              style: TextStyle(
                                fontSize: 20,
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ]
                              // السعر

                              ),

                          SizedBox(height: 10),
                          // السعر الإجمالي
                          Text(
                            "الإجمالي: ${totalPrice.toStringAsFixed(2)} \$",
                            // عرض الإجمالي مع خانتين عشريتين
                            style: TextStyle(
                              fontSize: 20,
                              color: primaryColor3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2),

                          // التقييمات
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 20),
                              SizedBox(width: 5),
                              Text(
                                "التقييم: ${state.productModel.rating}",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),


                          SizedBox(height: 20),

                          // أزرار الزيادة والنقصان
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // أيقونة النقصان
                              Container(
                                height: 60,
                                width: 410,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey.withOpacity(0.3)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          if (quantity > 1) quantity--;
                                        });
                                      },
                                    ),
                                    Text(
                                      quantity.toString(),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add, size: 18),
                                      onPressed: () {
                                        setState(() {
                                          quantity++;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // زر إضافة إلى السلة
                    Padding(
                      padding: EdgeInsets.all(2.0),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: ()async {
                            List<ProductModel> item=await getCachedData(key: "Cart",retrievedDataType:ProductModel.init() ,returnType:List )??[];
                            state.productModel.quantity=quantity;
                            item.add(state.productModel);
                            await cachedData(key:'Cart',data:item );
                            // إظهار رسالة تأكيد
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("تمت إضافة المنتج إلى السلة!",style: TextStyle(backgroundColor: Colors.green),),
                                duration: Duration(seconds: 2), // مدة عرض الرسالة
                              ),
                            );
                            print("Cart");
                            print(item);
                            // إضافة المنتج إلى السلة
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor, // لون الزر
                            padding: EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "أضف إلى السلة",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ProductDeatilsWidget;
          },
        ),
      ),
    );
  }
}
