
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../dataProviders/error/failures.dart';
import '../../../Product/data/model/ProductModel.dart';

import '../../data/repository/ProductDeatilsRepository.dart';

part 'ProductDeatils_event.dart';
part 'ProductDeatils_state.dart';

class ProductDeatils_bloc
    extends Bloc<ProductDeatilsEvent, ProductDeatilsState> {
  final ProductDeatilsRepository repository;
  ProductDeatils_bloc({required this.repository})
      : super(ProductDeatilsInitial());
  @override
  Stream<ProductDeatilsState> mapEventToState(
      ProductDeatilsEvent event) async* {
    if (event is GetAllProductDeatils) {
      yield ProductDeatilsLoading();
      final failureOrData = await repository.getAllProductDeatils(event.id);

      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ProductDeatilsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield ProductDeatilsILoaded(
            productModel:data,
          );
        },
      );
    }
  }
}