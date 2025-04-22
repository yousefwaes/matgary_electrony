part of 'Cart_bloc.dart';


abstract class CartState extends Equatable {
  const CartState();
}

class CartInitial extends CartState {
  @override
  List<Object> get props => [];
}

class CartLoading extends CartState {
  @override
  List<Object> get props => [];
}

class CartILoaded extends CartState {
  List<ProductModel> productModel;

  CartILoaded({required this.productModel});

  @override
  List<Object> get props => [productModel];
}

class CartError extends CartState {
  String errorMessage;

  CartError({required this.errorMessage});

  @override
  List<Object> get props => [];
}


class SendOrderInitial extends CartState {
  @override
  List<Object> get props => [];
}

class SendOrderLoading extends CartState {
  @override
  List<Object> get props => [];
}

class SendOrderILoaded extends CartState {
  List<ProductModel> productModel;

  SendOrderILoaded({required this.productModel});

  @override
  List<Object> get props => [productModel];
}

class SendOrderError extends CartState {
  String errorMessage;

  SendOrderError({required this.errorMessage});

  @override
  List<Object> get props => [];
}
