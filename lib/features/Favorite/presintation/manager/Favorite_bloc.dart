
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:matgary_electrony/dataProviders/error/failures.dart';

import '../../../Product/data/model/ProductModel.dart';
import '../../data/repository/FavoriteRepository.dart';


part 'Favorite_event.dart';
part 'Favorite_state.dart';

class Favorite_bloc
    extends Bloc<FavoriteEvent, FavoriteState> {
  final FavoriteRepository repository;

  Favorite_bloc({required this.repository}) : super(FavoriteInitial());
  @override
  Stream<FavoriteState> mapEventToState(FavoriteEvent event) async* {
    if (event is isFavorite) {
      yield FavoriteLoading();
      final failureOrData = await repository.favorite();

      yield* failureOrData.fold(
            (failure) async* {
          log('yield is error');
          yield FavoriteError(errorMessage: mapFailureToMessage(failure));
        },
            (data) async* {
          log('yield is loaded');
          yield FavoriteILoaded(
            productModel: data,
          );
        },
      );
    }

  }}
