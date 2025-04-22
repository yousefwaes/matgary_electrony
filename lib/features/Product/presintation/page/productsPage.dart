import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart'; // استيراد حزمة lottie
import 'package:matgary_electrony/features/Product/presintation/Widget/ProductCard.dart';
import '../../../../core/util/ScreenUtil.dart';
import '../../../../injection_container.dart';
import '../../../Home/presintation/Widget/BottomNavigation.dart';
import '../../../Home/presintation/Widget/my_app_bar.dart';
import '../manager/Product_bloc.dart';


class ProductPage extends StatefulWidget {
final String id;

  ProductPage({super.key,required this.id});


  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {

  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();

  int itemisselected = 0;
  String valueInput = "";
  Widget ProductWidget = Container();

  ScreenUtil screenUtil = ScreenUtil();

  Widget build(BuildContext context) {

    screenUtil.init(context);

    return Scaffold(
      appBar: myAppBar(context, "المنتجات"),
      bottomNavigationBar: Bottomnavigation(),
      body: BlocProvider(
        create: (context) => sl<Product_bloc>(),
        child: BlocConsumer<Product_bloc, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              print(state.errorMessage);
            }
          },
          builder: (context, state) {
            if (state is ProductInitial) {
              BlocProvider.of<Product_bloc>(context)
                  .add(GetAllProduct(id: widget.id.toString()));
              return Center(
                child: Lottie.asset('assets/json/loading.json'),
              );
            }

            if (state is ProductLoading) {
              ProductWidget = Column(
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

            if (state is ProductILoaded) {
              //TODO::Show Product here

              return state.productModel.isEmpty
                  ? Center(
                child: SvgPicture.asset("assets/images/not-found.svg"),
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
            return ProductWidget;
          },
        ),
      ),
    );
  }
}