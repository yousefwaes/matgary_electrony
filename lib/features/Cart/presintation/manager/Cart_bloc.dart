
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:matgary_electrony/dataProviders/error/failures.dart';
import '../../../Product/data/model/ProductModel.dart';
import '../../data/repository/CartRepository.dart';


part 'Cart_event.dart';
part 'Cart_state.dart';

class Cart_bloc
    extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  Cart_bloc({required this.repository}) : super(CartInitial());
  @override
  Stream<CartState> mapEventToState(CartEvent event) async* {
    if (event is Cart) {
      yield CartLoading();
      final failureOrData = await repository.cart();

      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield CartError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield CartILoaded(
            productModel: data,
          );
        },
      );
    }

    if (event is SendOrder) {
      yield SendOrderLoading();
      final failureOrData = await repository.sendOrder();

      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield SendOrderError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield SendOrderILoaded(
            productModel: data,
          );
        },
      );
    }

  }}
