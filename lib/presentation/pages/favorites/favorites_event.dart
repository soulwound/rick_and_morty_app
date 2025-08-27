import 'package:rick_and_morty_app/data/models/card_model.dart';

abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class ToggleFavorite extends FavoritesEvent {
  final CardModel card;
  ToggleFavorite(this.card);
}

class SortFavorites extends FavoritesEvent {
  final bool ascending;
  SortFavorites({this.ascending = true});
}