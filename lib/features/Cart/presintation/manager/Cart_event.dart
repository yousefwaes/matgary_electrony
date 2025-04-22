part of 'Cart_bloc.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
}

class Cart extends CartEvent {

  @override
  List<Object> get props => [];

  const Cart();
}

class SendOrder extends CartEvent {
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final double total;
  final List<Map<String, dynamic>> items;

  const SendOrder({
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.total,
    required this.items,
  });

  @override
  List<Object> get props => [customerName, customerAddress, customerPhone, total, items];
}

class GetLast10Cart extends CartEvent {
  @override
  List<Object> get props => [];
}