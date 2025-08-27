import 'package:rick_and_morty_app/data/models/card_model.dart';

abstract class FavoritesState {}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<CardModel> favorites;
  final bool sortedAscending; // Состояние сортировки

  FavoritesLoaded(this.favorites, {this.sortedAscending = true});
}