part of 'Favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();
}

class isFavorite extends FavoriteEvent {

  @override
  List<Object> get props => [];

  const isFavorite();
}


class GetLast10Favorite extends FavoriteEvent {
  @override
  List<Object> get props => [];
}