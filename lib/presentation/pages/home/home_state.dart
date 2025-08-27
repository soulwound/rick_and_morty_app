import '../../../data/models/card_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<CardModel> cards;
  final int page;
  final bool hasReachedEnd;
  final bool fromCache;


  HomeLoaded({
    required this.cards,
    required this.page,
    required this.hasReachedEnd,
    this.fromCache = false
  });

  HomeLoaded copyWith({
    List<CardModel>? cards,
    int? page,
    bool? hasReachedEnd
  }) {
    return HomeLoaded(
      cards: cards ?? this.cards, 
      page: page ?? this.page, 
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd
    );
  }
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}