import 'package:dartz/dartz.dart';
import 'package:matgary_electrony/dataProviders/error/failures.dart';
import 'package:matgary_electrony/dataProviders/local_data_provider.dart';
import 'package:matgary_electrony/dataProviders/network/Network_info.dart';
import 'package:matgary_electrony/dataProviders/network/data_source_url.dart';
import 'package:matgary_electrony/dataProviders/remote_data_provider.dart';
import 'package:matgary_electrony/dataProviders/repository.dart';
import 'package:matgary_electrony/features/Product/data/model/ProductModel.dart';

class ProductRepository extends Repository {
  final RemoteDataProvider remoteDataProvider; //get the data from the internet
  final NetworkInfo networkInfo; //check if the device is connected to internet
  final LocalDataProvider localDataProvider;

  ProductRepository(
      {required this.remoteDataProvider,
      required this.networkInfo,
      required this.localDataProvider});

  Future<Either<Failure, dynamic>> getAllProduct(String id) async {
    return await sendRequest(
      checkConnection: networkInfo.isConnected,
      remoteFunction: () async {
        List<ProductModel> remoteData = await remoteDataProvider.getData(
          url: 'categories/$id/products',
          returnType: List,
          retrievedDataType: ProductModel.init(),
        );
        return remoteData;
      },
      getCacheDataFunction: () async {},
    );
  }


}
