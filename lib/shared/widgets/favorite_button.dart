import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/data/models/card_model.dart';
import 'package:rick_and_morty_app/presentation/pages/favorites/favorites_bloc.dart';
import 'package:rick_and_morty_app/presentation/pages/favorites/favorites_event.dart';

class FavoriteButton extends StatelessWidget{
  final CardModel card;
  final bool isFavorite;

  const FavoriteButton({
    super.key,
    required this.card,
    required this.isFavorite
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => context.read<FavoritesBloc>().add(ToggleFavorite(card)), 
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
        child: Icon(
          isFavorite ? Icons.star : Icons.star_border,
          key: ValueKey(isFavorite),
          color: isFavorite ? Colors.amber : null,
        ),
      )
    );
  }
}