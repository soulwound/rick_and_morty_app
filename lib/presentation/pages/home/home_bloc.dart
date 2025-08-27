import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';
import '../../../data/card_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState>{
  final CardRepository repository;
  int _page = 1;
  bool _isLoading = false;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<FetchCards>(_onFetchCards);
    on<FetchNextPage>(_onFetchNextPage);
  }

  Future<void> _onFetchCards(FetchCards event, Emitter<HomeState> emit) async {
    _page = 1;
    emit(HomeLoading());
    try {
      final result = await repository.getCards(page: _page, count: 20);
      if (result.cards.isEmpty){
        emit(HomeError("Нет данных"));
      } else{
        emit(HomeLoaded(cards: result.cards, page: _page, hasReachedEnd: result.cards.isEmpty, fromCache: result.fromCache));
      }
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onFetchNextPage(FetchNextPage event, Emitter<HomeState> emit) async {
    if (_isLoading || state is !HomeLoaded) return;
    final currentState = state as HomeLoaded;
    _isLoading = true;
    _page++;

    if (currentState.hasReachedEnd) return;

    try {
      final newCards = await repository.getCards(page: _page);
      final cards = newCards.cards;
      final allCards = [
        ...currentState.cards,
        ...cards.where(
          (c) => !currentState.cards.any((old) => old.id == c.id))
      ];
      emit(HomeLoaded(
        cards: allCards, 
        page: _page, 
        hasReachedEnd: cards.isEmpty,
        fromCache: newCards.fromCache)
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
    finally {
      _isLoading = false;
    }
  }
}