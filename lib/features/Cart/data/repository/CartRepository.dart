import 'package:dartz/dartz.dart';
import 'package:matgary_electrony/dataProviders/error/failures.dart';
import 'package:matgary_electrony/dataProviders/local_data_provider.dart';
import 'package:matgary_electrony/dataProviders/network/Network_info.dart';
import 'package:matgary_electrony/dataProviders/network/data_source_url.dart';
import 'package:matgary_electrony/dataProviders/remote_data_provider.dart';
import 'package:matgary_electrony/dataProviders/repository.dart';

import '../../../Product/data/model/ProductModel.dart';

class CartRepository extends Repository {
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final NetworkInfo networkInfo; //check if the device is connected to internet
  final LocalDataProvider localDataProvider;

  CartRepository(
      {required this.remoteDataProvider,
      required this.networkInfo,
      required this.localDataProvider});

  Future<Either<Failure, dynamic>> cart() async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        List<ProductModel> remoteData = await localDataProvider.getCachedData(
           key: "Cart",
          returnType: List,
          retrievedDataType: ProductModel.init(),
        );
        return remoteData;
      },
      getCacheDataFunction: () async {},
    );
  }


  Future<Either<Failure, dynamic>> sendOrder() async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        List<ProductModel> remoteData = await remoteDataProvider.sendJsonData(
          url: DataSourceURL.sendOrder,
          jsonData:{
            "customerName":    "أحمد علي",
            "customerAddress": "شارع التحلية، جدة",
            "customerPhone":   "0512345678",
            "total":           350.00,
            "items": [
              { "productId": 1, "quantity": 2, "price": 120.00 },
              { "productId": 2, "quantity": 1, "price": 110.00}
            ]

          } ,
          returnType: List,
          retrievedDataType: ProductModel.init(),
        );
        return remoteData;
      },
      getCacheDataFunction: () async {},
    );
  }
  //getCartsByCategory(String categoryId) {}
}
