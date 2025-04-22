import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart'; // استيراد حزمة lottie
import 'package:matgary_electrony/core/AppTheme.dart';
import 'package:matgary_electrony/dataProviders/network/data_source_url.dart';
import '../../../../core/util/ScreenUtil.dart';
import '../../../../injection_container.dart';
import '../Widget/BottomNavigation.dart';
import '../../../Product/presintation/Widget/ProductCard.dart';
import '../Widget/my_app_bar.dart';
import '../../../Product/presintation/page/productsPage.dart';
import '../manager/Home_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController _scrollController = ScrollController();
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  int itemisselected = 0;
  String valueInput = "";
  Widget HomeWidget = Container();
  ScreenUtil screenUtil = ScreenUtil();

  Widget build(BuildContext context) {

    screenUtil.init(context);
    return Scaffold(
      extendBody: true,
      appBar: myAppBar(context, "الرئيسية"),

      bottomNavigationBar: Material(
        elevation: 0,
        color: Colors.transparent,
        child: Bottomnavigation(),
      ), // إضافة شريط التنقل السفلي هنا
      body: SingleChildScrollView(
        // إضافة SingleChildScrollView هنا

        child: Column(
          children: [
            SizedBox(height: 5),
            BlocProvider(
              create: (context) => sl<Home_bloc>(),
              child: BlocConsumer<Home_bloc, HomeState>(
                listener: (context, state) {
                  if (state is CarouselError) {
                    print(state.errorMessage);
                  }
                },
                builder: (context, state) {
                  if (state is HomeInitial) {
                    BlocProvider.of<Home_bloc>(context).add(CarouselEvent());
                    return Center(
                        /* child: Lottie.asset(
                          'assets/json/loading.json'), */ // عرض Lottie animation
                        );
                  }

                  if (state is CarouselLoading) {
                    return Center(
                        /*  child: Lottie.asset(
                          'assets/json/loading.json'),*/ // عرض Lottie animation
                        );
                  }

                  if (state is CarouselILoaded) {
                    //TODO::Show Product here

                    return Column(
                      children: [
                        SizedBox(height: 5),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 250,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration: Duration(milliseconds: 900),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            viewportFraction: 0.8,
                            enlargeCenterPage: true,
                            pauseAutoPlayOnTouch: true,
                          ),
                          items: state.carouselModel.map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: MediaQuery.of(context).size.width * 0.9,
                                  margin: EdgeInsets.symmetric(horizontal: 5.0), // إضافة مسافة بين العناصر
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    boxShadow: [
                                      BoxShadow(
                                       // color: Colors.black.withOpacity(0.8),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                    image: DecorationImage(
                                      image: NetworkImage(DataSourceURL.baseImage+i.image),
                                      fit: BoxFit.cover, // تغيير إلى cover لتناسب الصورة
                                    ),
                                  ),
                                  child: Align(
                                    alignment: Alignment.bottomCenter, // محاذاة النص في الأسفل
                                    child: Container(
                                      padding: EdgeInsets.all(10), // إضافة padding للنص
                                      decoration: BoxDecoration(
                                       // color: Colors.black54, // خلفية نصية داكنة
                                        borderRadius: BorderRadius.vertical(
                                          bottom: Radius.circular(15.0), // انحناء الحواف السفلية
                                        ),
                                      ),


                                      ),
                                    ),

                                );
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }
              /*    return Column(
                    children: [
                      SizedBox(height: 5),
                      CarouselSlider(
                        options: CarouselOptions(
                          height: 250,
                          autoPlay: true,
                          autoPlayInterval: Duration(seconds: 3),
                          autoPlayAnimationDuration:
                          Duration(milliseconds: 800),
                          autoPlayCurve: Curves.fastOutSlowIn,
                          viewportFraction: 0.8,
                          enlargeCenterPage: true,
                          pauseAutoPlayOnTouch: true,
                        ),
                        items: state.carouselModel.map((i) {
                          return Builder(
                            builder: (BuildContext context) {
                              return Container(
                                width:
                                MediaQuery.of(context).size.width * 0.9,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
// انحناء الحواف
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
                                    image: NetworkImage(i.image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              );
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  )*/


                  return HomeWidget;
                },
              ),
            ),

            SizedBox(height: 25),
            //الاقسام
            BlocProvider(
              create: (context) => sl<Home_bloc>(),
              child: BlocConsumer<Home_bloc, HomeState>(
                listener: (context, state) {
                  if (state is CategoriesError) {
                    print(state.errorMessage);
                  }
                },
                builder: (context, state) {
                  if (state is HomeInitial) {
                    BlocProvider.of<Home_bloc>(context).add(CategoriesEvent());
                 /*   return Center(
                      child: Lottie.asset('assets/json/loading.json'),
                    );*/
                  }

                  if (state is CategoriesLoading) {
                    /*return Center(
                      child: Lottie.asset('assets/json/loading.json'),
                    );*/
                  }

                  if (state is CategoriesILoaded) {
                    //TODO::Show Product here

                    return SizedBox(
                      height: 175,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                          Padding(

                            padding: EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 5.15),
                            child: Text(
                              'الاقسام',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.categoriesModel.length,
                              itemBuilder: (context, index) {
                                final category = state.categoriesModel[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProductPage(id:category.id.toString()),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundImage:
                                              NetworkImage(DataSourceURL.baseImage+category.image),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          category.name,
                                          style: const TextStyle(

                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                         /*   shadows: [
                                              Shadow(
                                                blurRadius: 9.0,
                                                color: primaryColor,
                                                offset: Offset(7.5, 5.9), // الظل موجه للأسفل
                                              ),
                                            ],*/
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return HomeWidget;
                },
              ),
            ),

            //featured PRODECT
            BlocProvider(
              create: (context) => sl<Home_bloc>(),
              child: BlocConsumer<Home_bloc, HomeState>(
                listener: (context, state) {
                  if (state is featuredProductsError) {
                    print(state.errorMessage);
                  }
                },
                builder: (context, state) {
                  if (state is HomeInitial) {
                    BlocProvider.of<Home_bloc>(context)
                        .add(featuredProductsEvent());
                 return   Center(
                      child: Lottie.asset('assets/json/loading.json'), // عرض الرسوم المتحركة
                    );
                  }

                  if (state is featuredProductsLoading) {
                   return Center(
                      child: Lottie.asset('assets/json/loading.json'),
                    );
                  }

                  if (state is featuredProductsILoaded) {
                    //TODO::Show Product here
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 8.15),
                            child: Text(
                              'المنتجات المميزه', // Title for the categories
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                            itemCount: state.productModel.length,
                            itemBuilder: (context, index) {
                              return Productcard(
                                productModel: state.productModel[index],
                              );
                            },
                            shrinkWrap: true,
                            physics:
                                NeverScrollableScrollPhysics(), // منع التمرير في GridView
                          ),
                        ],
                      ),
                    );
                  }

                  return HomeWidget;
                },
              ),
            ),




          /*  BlocProvider(
              create: (context) => sl<Home_bloc>(),
              child: BlocConsumer<Home_bloc, HomeState>(
                listener: (context, state) {
                  if (state is featuredProductsError) {
                    print(state.errorMessage);
                  }
                },
                builder: (context, state) {
                  if (state is HomeInitial) {
                    BlocProvider.of<Home_bloc>(context)
                        .add(featuredProductsEvent());
                   *//* return Center(
                      child: Lottie.asset('assets/json/loading.json'),
                    );*//*
                  }

                  if (state is featuredProductsLoading) {
                    *//*return Center(
                      child: Lottie.asset('assets/json/loading.json'),
                    );*//*
                  }

                  if (state is featuredProductsILoaded) {
                    //TODO::Show Product here

                    return SizedBox(
                      height: 175,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 5.15),
                            child: Text(
                              'featured PRODECT', // Title for the categories
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.productModel.length,
                              itemBuilder: (context, index) {
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Productcard(
                                      productModel: state.productModel[index]),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return HomeWidget;
                },
              ),
            ),*/
          ],
        ),
      ),
    );
  }
}
