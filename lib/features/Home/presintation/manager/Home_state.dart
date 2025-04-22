part of 'Home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();
}

class HomeInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class CarouselLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class CarouselILoaded extends HomeState {
  final List<CarouselModel> carouselModel;

  CarouselILoaded({required this.carouselModel});

  @override
  List<Object> get props => [carouselModel];
}

class CarouselError extends HomeState {
  final String errorMessage;

  CarouselError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}


class CategoriesInitial extends HomeState {
  @override
  List<Object> get props => [];
}

class CategoriesLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class CategoriesILoaded extends HomeState {
  final List<CategoriesModel> categoriesModel;

  CategoriesILoaded({required this.categoriesModel});

  @override
  List<Object> get props => [categoriesModel];
}

class CategoriesError extends HomeState {
  final String errorMessage;

  CategoriesError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}






class featuredProductsLoading extends HomeState {
  @override
  List<Object> get props => [];
}

class featuredProductsILoaded extends HomeState {
  final List<ProductModel> productModel;

  featuredProductsILoaded({required this.productModel});

  @override
  List<Object> get props => [productModel];
}

class featuredProductsError extends HomeState {
  final String errorMessage;

  featuredProductsError({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}