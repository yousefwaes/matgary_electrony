part of 'ProductDeatils_bloc.dart';

abstract class ProductDeatilsState extends Equatable {
  const ProductDeatilsState();
}

class ProductDeatilsInitial extends ProductDeatilsState {
  @override
  List<Object> get props => [];
}

class ProductDeatilsLoading extends ProductDeatilsState {
  @override
  List<Object> get props => [];
}

class ProductDeatilsILoaded extends ProductDeatilsState {
  ProductModel productModel;

  ProductDeatilsILoaded({required this.productModel});

  @override
  List<Object> get props => [productModel];
}

class ProductDeatilsError extends ProductDeatilsState {
  String errorMessage;

  ProductDeatilsError({required this.errorMessage});

  @override
  List<Object> get props => [];
}
