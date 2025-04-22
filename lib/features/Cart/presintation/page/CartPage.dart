import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:matgary_electrony/features/Home/presintation/page/HomePage.dart';
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
  Map<int, int> quantities = {}; // Store quantities by product ID
  GlobalKey<ScaffoldState> scaffolKey = GlobalKey<ScaffoldState>();
  int itemisselected = 0;
  String valueInput = "";
  Widget CartWidget = Container();
  late ScreenUtil screenUtil;

  // Controllers for customer information
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isCart();
    screenUtil = ScreenUtil();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    super.dispose();
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
        // Initialize quantities for each product
        for (var product in _cartProducts) {
          quantities[product.id ?? 0] = 1;
        }
      });
    }
  }

  // Calculate total with quantities
  double calculateTotal(List<ProductModel> products) {
    double total = 0.0;
    for (var product in products) {
      int quantity = quantities[product.id ?? 0] ?? 1;
      total +=
          (double.tryParse(product.price.toString() ?? '0') ?? 0) * quantity;
    }
    return total;
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
            if (state is SendOrderILoaded) {
               cachedData(key: 'Cart', data: []);
               cachedData(key: 'phoneNumber', data:_phoneController.text);
               Navigator.push(
                   context,
                   MaterialPageRoute(
                     builder: (context) => HomePage(),
                   ));


            }
            if (state is CartILoaded) {
              return state.productModel.isEmpty
                  ? const Center(child: Text("السلة فارغة"))
                  : Stack(
                      children: [
                        // Product List
                        Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  90), // Increased padding to match new position
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.productModel.length,
                            itemBuilder: (context, index) {
                              final product = state.productModel[index];
                              // Initialize quantity if not already set
                              quantities[product.id ?? 0] ??= 1;

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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // أيقونة الحذف
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.red),
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
                                          BlocProvider.of<Cart_bloc>(context)
                                              .add(Cart());
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
                                                        BorderRadius.circular(
                                                            10),
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
                                                          if (quantities[
                                                                  product.id ??
                                                                      0]! >
                                                              1) {
                                                            setState(() {
                                                              quantities[product
                                                                      .id ??
                                                                  0] = quantities[
                                                                      product.id ??
                                                                          0]! -
                                                                  1;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                      Text(
                                                        quantities[
                                                                product.id ?? 0]
                                                            .toString(),
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
                                                            quantities[product
                                                                    .id ??
                                                                0] = quantities[
                                                                    product.id ??
                                                                        0]! +
                                                                1;
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
                                                    color: Colors.amber,
                                                    size: 18),
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: NetworkImage(
                                                DataSourceURL.baseImage +
                                                    product.image.toString()),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Fixed total at bottom
                        Positioned(
                          bottom: 20, // Changed from 0 to 20 to lift it up
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, -2),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "الإجمالي: ",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${calculateTotal(state.productModel).toStringAsFixed(2)} ريال",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        _showCheckoutConfirmation(context, calculateTotal(state.productModel));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryColor,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                      child: Text(
                                        "إتمام الشراء",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  // Show checkout confirmation dialog
  void _showCheckoutConfirmation(BuildContext context, double total) {
    // Store the parent context that has access to the BlocProvider
    final parentContext = context;
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Container(
              width: double.maxFinite,
              constraints: BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "تأكيد الطلب",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  InputField(
                    controller: _nameController,
                    labelText: "اسم العميل",
                    prefixIcon: Icons.person,
                  ),
                  SizedBox(height: 16),
                  InputField(
                    controller: _phoneController,
                    labelText: "رقم الهاتف",
                    prefixIcon: Icons.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  SizedBox(height: 16),
                  InputField(
                    controller: _addressController,
                    labelText: "العنوان",
                    prefixIcon: Icons.location_on,
                    maxLines: 3,
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "تفاصيل الطلب",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Divider(thickness: 1.5),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${total.toStringAsFixed(2)} ريال",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            Text(
                              "المجموع:",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey[400]!),
                            ),
                          ),
                          child: Text(
                            "إلغاء",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Process order here
                            if (_nameController.text.isEmpty ||
                                _addressController.text.isEmpty ||
                                _phoneController.text.isEmpty) {
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "الرجاء إدخال جميع البيانات المطلوبة")),
                              );
                              return;
                            }else {

                              // Use parentContext to access the BlocProvider
                              BlocProvider.of<Cart_bloc>(parentContext).add(
                                  SendOrder());

                              // Here you'd typically send the order to your backend
                              ScaffoldMessenger.of(dialogContext).showSnackBar(
                                SnackBar(content: Text("تم تأكيد الطلب بنجاح")),
                              );
                              Navigator.of(dialogContext).pop();
                            }},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "تأكيد الطلب",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Custom Input Field Widget
  Widget InputField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          prefixIcon: Icon(prefixIcon, color: primaryColor),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: primaryColor, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        ),
      ),
    );
  }
}
