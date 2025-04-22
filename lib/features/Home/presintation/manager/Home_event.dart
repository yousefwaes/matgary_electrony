part of 'Home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class CarouselEvent extends HomeEvent {
  @override
  List<Object> get props => [];
  const CarouselEvent();
}

class CategoriesEvent extends HomeEvent {
  @override
  List<Object> get props => [];
  const CategoriesEvent();
}

class featuredProductsEvent extends HomeEvent {
  @override
  List<Object> get props => [];
  const featuredProductsEvent();
}


class GetLast10Home extends HomeEvent {
  @override
  List<Object> get props => [];
}