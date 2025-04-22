import 'package:dartz/dartz.dart';
import 'package:matgary_electrony/dataProviders/error/failures.dart';
import 'package:matgary_electrony/dataProviders/local_data_provider.dart';
import 'package:matgary_electrony/dataProviders/network/Network_info.dart';
import 'package:matgary_electrony/dataProviders/network/data_source_url.dart';
import 'package:matgary_electrony/dataProviders/remote_data_provider.dart';
import 'package:matgary_electrony/dataProviders/repository.dart';
import 'package:matgary_electrony/features/Product/data/model/ProductModel.dart';

import '../model/CarouselModel.dart';
import '../model/CategoriesModel.dart';

class HomeRepository extends Repository {
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final NetworkInfo networkInfo; //check if the device is connected to internet
  final LocalDataProvider localDataProvider;

  HomeRepository(
      {required this.remoteDataProvider,
      required this.networkInfo,
      required this.localDataProvider});

  Future<Either<Failure, dynamic>> offers () async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        List<CarouselModel> remoteData = await remoteDataProvider.getData(
          url: DataSourceURL.offers,
          returnType: List,
          retrievedDataType: CarouselModel.init(),
        );
        print(remoteData);
        return remoteData;
      },
      getCacheDataFunction: () async {},
    );
  }





  Future<Either<Failure, dynamic>> categories () async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        List<CategoriesModel> remoteData = await remoteDataProvider.getData(
          url: DataSourceURL.categories,
          returnType: List,
          retrievedDataType: CategoriesModel.init(),
        );
        print(remoteData);
        return remoteData;
      },
      getCacheDataFunction: () async {},
    );
  }

  Future<Either<Failure, dynamic>> featuredProducts () async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        List<ProductModel> remoteData = await remoteDataProvider.getData(
          url: DataSourceURL.featuredProducts,
          returnType: List,
          retrievedDataType: ProductModel.init(),
        );
        print(remoteData);
        return remoteData;
      },
      getCacheDataFunction: () async {},
    );
  }

}
