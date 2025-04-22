part of 'Cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class Cart extends CartEvent {

  @override
  List<Object> get props => [];

  const Cart();
}


class GetLast10Cart extends CartEvent {
  @override
  List<Object> get props => [];
}