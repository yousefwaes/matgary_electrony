part of 'Favorite_bloc.dart';


abstract class FavoriteState extends Equatable {
  const FavoriteState();
}

class FavoriteInitial extends FavoriteState {
  @override
  List<Object> get props => [];
}

class FavoriteLoading extends FavoriteState {
  @override
  List<Object> get props => [];
}

class FavoriteILoaded extends FavoriteState {
  List<ProductModel> productModel;

  FavoriteILoaded({required this.productModel});

  @override
  List<Object> get props => [productModel];
}

class FavoriteError extends FavoriteState {
  String errorMessage;

  FavoriteError({required this.errorMessage});

  @override
  List<Object> get props => [];
}
