
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:matgary_electrony/dataProviders/error/failures.dart';
import 'package:matgary_electrony/features/Home/data/model/CarouselModel.dart';
import 'package:matgary_electrony/features/Home/data/model/CategoriesModel.dart';
import 'package:matgary_electrony/features/Product/data/model/ProductModel.dart';
import '../../data/repository/HomeRepository.dart';

part 'Home_event.dart';
part 'Home_state.dart';

class Home_bloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  Home_bloc({required this.repository}) : super(HomeInitial());

  @override
  Stream<HomeState> mapEventToState(HomeEvent event) async* {

    if (event is CarouselEvent) {
      yield CarouselLoading();
      final failureOrData = await repository.offers();

      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield CarouselError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield CarouselILoaded(
            carouselModel: data,
          );
        },
      );
    }


    if (event is CategoriesEvent) {
      yield CategoriesLoading();
      final failureOrData = await repository.categories();

      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield CategoriesError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield CategoriesILoaded(
            categoriesModel: data,
          );
        },
      );
    }



    if (event is featuredProductsEvent) {
      yield featuredProductsLoading();
      final failureOrData = await repository.featuredProducts();

      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield featuredProductsError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield featuredProductsILoaded(
            productModel: data,
          );
        },
      );
    }

  }
}