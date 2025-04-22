
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:matgary_electrony/dataProviders/error/failures.dart';
import '../../data/repository/OrdersRepository.dart';


part 'Orders_event.dart';
part 'Orders_state.dart';

class Orders_bloc
    extends Bloc<OrdersEvent, OrdersState> {
  final OrdersRepository repository;

  Orders_bloc({required this.repository}) : super(OrdersInitial());
  @override
  Stream<OrdersState> mapEventToState(OrdersEvent event) async* {
    if (event is GetAllOrders) {
      yield OrdersLoading();
      final failureOrData = await repository.getAllOrders(event.id);

      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield OrdersError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield OrdersILoaded(
            OrdersModel: data,
          );
        },
      );
    }

  }}
