import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/data/card_repository.dart';
import '../../../data/models/card_model.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final CardRepository repository;

  FavoritesBloc(this.repository) : super(FavoritesInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<ToggleFavorite>(_onToggleFavorite);
    on<SortFavorites>(_onSortFavorites);

    final favorites = repository.getFavorites();
    emit(FavoritesLoaded(favorites));

  }

  Future<void> _onLoadFavorites(
    LoadFavorites event,
    Emitter<FavoritesState> emit
  ) async {
      final favorites = repository.getFavorites();
      emit(FavoritesLoaded(favorites));
    }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<FavoritesState> emit
  ) async {
    await repository.ToggleFavorite(event.card);
    final favorites = repository.getFavorites();
    emit(FavoritesLoaded(favorites));
  }
  
  void _onSortFavorites(SortFavorites event, Emitter<FavoritesState> emit) {
    if (state is FavoritesLoaded) {
      final current = (state as FavoritesLoaded);
      final sorted = [...current.favorites]..sort((a, b){
        return event.ascending
          ? a.name.compareTo(b.name)
          : b.name.compareTo(a.name);
      });
      emit(FavoritesLoaded(sorted, sortedAscending: event.ascending));
    }
  }
}