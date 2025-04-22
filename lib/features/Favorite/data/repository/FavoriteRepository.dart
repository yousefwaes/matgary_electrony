import 'package:dartz/dartz.dart';
import 'package:matgary_electrony/dataProviders/error/failures.dart';
import 'package:matgary_electrony/dataProviders/local_data_provider.dart';
import 'package:matgary_electrony/dataProviders/network/Network_info.dart';
import 'package:matgary_electrony/dataProviders/remote_data_provider.dart';
import 'package:matgary_electrony/dataProviders/repository.dart';
import '../../../Product/data/model/ProductModel.dart';

class FavoriteRepository extends Repository {
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final NetworkInfo networkInfo; //check if the device is connected to internet
  final LocalDataProvider localDataProvider;

  FavoriteRepository(
      {required this.remoteDataProvider,
      required this.networkInfo,
      required this.localDataProvider});

  Future<Either<Failure, dynamic>> favorite() async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        List<ProductModel> remoteData = await localDataProvider.getCachedData(
          returnType: List,
          retrievedDataType: ProductModel.init(), key: 'FavoriteProducts',
        );
        return remoteData;
      },
      getCacheDataFunction: () async {},
    );
  }

  //getFavoritesByCategory(String categoryId) {}
}
