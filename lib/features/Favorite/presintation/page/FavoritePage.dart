import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart'; // استيراد حزمة lottie
import '../../../../core/common.dart';
import '../../../../core/util/ScreenUtil.dart';
import '../../../../injection_container.dart';
import '../../../Home/presintation/Widget/BottomNavigation.dart';
import '../../../Home/presintation/Widget/my_app_bar.dart';
import '../../../Product/data/model/ProductModel.dart';
import '../../../Product/presintation/Widget/ProductCard.dart';
import '../manager/Favorite_bloc.dart';


class FavoritePage extends StatefulWidget {


  FavoritePage({super.key});


  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  List<ProductModel> _favoriteProducts = [];



  @override
  void initState() {
    super.initState();
    _isFavorite();
  }

  Future<void> _isFavorite() async {
    final favorites = await getCachedData(
      key: "FavoriteProducts",
      retrievedDataType: ProductModel.init(),
      returnType: List,
    ) ?? [];

    if (mounted) {
      setState(() {
        _favoriteProducts = List<ProductModel>.from(favorites);
      });
    }
  }


  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  int itemisselected = 0;
  String valueInput = "";
  Widget FavoriteWidget = Container();
  ScreenUtil screenUtil = ScreenUtil();

  Widget build(BuildContext context) {
    screenUtil.init(context);
    return Scaffold(
      appBar: myAppBar(context, "المفضله"),
      bottomNavigationBar: Material(
        elevation: 0,
        color: Colors.transparent,
         child: Bottomnavigation(),
      ),
      body: BlocProvider(
        create: (context) => sl<Favorite_bloc>(),
        child: BlocConsumer<Favorite_bloc, FavoriteState>(
          listener: (context, state) {
            if (state is FavoriteError) {
              print(state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is FavoriteInitial) {
              BlocProvider.of<Favorite_bloc>(context)
                  .add(isFavorite());
              return Center(
                child: Lottie.asset('assets/json/loading.json'),
              );
            }

            if (state is FavoriteLoading) {
              FavoriteWidget = Column(
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

            if (state is FavoriteILoaded) {
              //TODO::Show Favorite here

              return state.productModel.isEmpty
                  ? Center(
                child: Text("لم يتم اضافه منتج الى المفضله")
              )
                  : SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  itemCount: state.productModel.length,
                  itemBuilder: (context, index) {
                    return Productcard(
                        productModel: state.productModel[index]);
                  },
                ),
              );
            }
            return FavoriteWidget;
          },
        ),
      ),
    );
  }
}