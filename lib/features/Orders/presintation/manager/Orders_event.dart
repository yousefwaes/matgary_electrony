part of 'Orders_bloc.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();
}

class GetAllOrders extends OrdersEvent {
final String id;
  @override
  List<Object> get props => [];

  const GetAllOrders({required this.id});
}


class GetLast10Orders extends OrdersEvent {
  @override
  List<Object> get props => [];
}
