import 'package:flutter/material.dart';
import 'package:matgary_electrony/core/AppTheme.dart';
import 'package:matgary_electrony/core/util/ScreenUtil.dart';
import 'package:matgary_electrony/features/ProductDeatils/presintation/page/ProductDeatilsPage.dart';
import '../../../../core/common.dart';
import '../../../../dataProviders/network/data_source_url.dart';
import '../../data/model/ProductModel.dart';
import 'package:favorite_button/favorite_button.dart';

class Productcard extends StatefulWidget {
  ProductModel productModel;

  Productcard({super.key, required this.productModel});

  @override
  _ProductcardState createState() => _ProductcardState();
}

class _ProductcardState extends State<Productcard> {
  ScreenUtil screenUtil = ScreenUtil();
  int quantity = 1; // عدد المنتجات
  List<ProductModel>? FavoriteList;
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    if (FavoriteList == null) {
      // لودينغ مؤقت
      return Center(child: CircularProgressIndicator(backgroundColor: AppTheme.primaryColor,));
    }
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDeatilsPage(id: widget.productModel.id.toString()),
            ),
          );
        },
        child: Container(margin: EdgeInsets.all(8.0), // مساحة حول العنصر
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), // زوايا مستديرة
            color: Colors.white,
            boxShadow: [

              BoxShadow(
                color: Colors.grey.withOpacity(0.9),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3), // ظل خفيف
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صورة المنتج
              Center(
                child: Container(
                  height: 100,

                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      image: NetworkImage(DataSourceURL.baseImage+widget.productModel.image.toString()),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8,),
              // اسم المنتج وأيقونة المفضلة
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // أيقونة المفضلة

                  FavoriteButton(
                    iconSize: 40,
                    isFavorite: FavoriteList!.any((product) => product.id == widget.productModel.id)?true:false,
                    valueChanged: (_isFavorite) async {

                      List<ProductModel> item = await getCachedData(
                          key: "FavoriteProducts",
                          retrievedDataType: ProductModel.init(),
                          returnType: List) ?? [];

                      if (_isFavorite == false) {
                        item.removeWhere((product) => product.id == widget.productModel.id);
                      } else {
                        item.add(widget.productModel);
                      }

                      await cachedData(key: 'FavoriteProducts', data: item);

                      // setState(() {
                      //    FavoriteList = item;
                      // });

                      print("FavoriteProducts");
                      print(item);
                    },
                  ),


                  // اسم المنتج
                  Expanded(
                    child: Text(
                      widget. productModel.name.toString(),
                      textAlign: TextAlign.end, // النص في اليمين
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3,),
              // السعر والتقييم
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // التقييم
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      SizedBox(width: 2),
                      Text(
                        widget. productModel.rating.toString(),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  // السعر
                  Text(

                    widget.productModel.price.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      color: primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              // أيقونات السلة والزيادة والنقصان
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // أيقونة السلة في أقصى اليسار

                  Center(
                    child: Container(
                      height: 30.0, // تقليل الارتفاع حسب الحاجة
                      child: IconButton(
                        icon: Icon(Icons.shopping_cart, color: Colors.black),
                        onPressed: () {
                          // إضافة المنتج إلى السلة
                        },
                      ),
                    ),
                  ),

                  //السعر السابق
                  Center(
                    child:Text(

                      widget.productModel.oldPrice.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        decoration: TextDecoration.lineThrough, // إضافة خط فوق النص
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ));
  }
  @override
  void initState() {
    super.initState();
    loadFavorites(); // نستخدم هذه بدلاً من initFavorite()
  }

  void loadFavorites() async {
    List<ProductModel> item = await getCachedData(
      key: "FavoriteProducts",
      retrievedDataType: ProductModel.init(),
      returnType: List,
    ) ?? [];

    setState(() {
      FavoriteList = item;
    });
  }

}
