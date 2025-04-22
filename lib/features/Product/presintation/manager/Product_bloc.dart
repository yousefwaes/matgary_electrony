
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:matgary_electrony/dataProviders/error/failures.dart';
import '../../data/repository/ProductRepository.dart';
import 'package:matgary_electrony/features/Product/data/model/ProductModel.dart';


part 'Product_event.dart';
part 'Product_state.dart';

class Product_bloc
    extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  Product_bloc({required this.repository}) : super(ProductInitial());
  @override
  Stream<ProductState> mapEventToState(ProductEvent event) async* {
    if (event is GetAllProduct) {
      yield ProductLoading();
      final failureOrData = await repository.getAllProduct(event.id);

      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield ProductError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield ProductILoaded(
            productModel: data,
          );
        },
      );
    }

  }}
