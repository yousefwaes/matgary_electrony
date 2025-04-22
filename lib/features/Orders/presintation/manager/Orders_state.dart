part of 'Orders_bloc.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();
}

class OrdersInitial extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersLoading extends OrdersState {
  @override
  List<Object> get props => [];
}

class OrdersILoaded extends OrdersState {
  List<OrdersModel> ordersModel;

  OrdersILoaded({required this.ordersModel});

  @override
  List<Object> get props => [ordersModel];
}

class OrdersError extends OrdersState {
  String errorMessage;

  OrdersError({required this.errorMessage});

  @override
  List<Object> get props => [];
}
