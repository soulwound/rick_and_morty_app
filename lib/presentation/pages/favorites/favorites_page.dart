import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/presentation/pages/favorites/favorites_event.dart';
import 'package:rick_and_morty_app/shared/widgets/theme_toggle_button.dart';
import '../../../shared/widgets/character_card.dart';
import '../../../data/models/card_model.dart';
import 'favorites_bloc.dart';
import 'favorites_state.dart';

class FavoritesPage extends StatelessWidget{
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Избранное'),
        actions: [
          BlocBuilder<FavoritesBloc, FavoritesState>(
            builder: (context, state) {
              bool ascending = true;
              if (state is FavoritesLoaded) {
                ascending = state.sortedAscending;
              }
              return PopupMenuButton(
                icon: Icon(Icons.sort),
                onSelected: (value) {
                  if (value == 'asc') {
                    context.read<FavoritesBloc>().add(SortFavorites(ascending: true));
                  } else {
                    context.read<FavoritesBloc>().add(SortFavorites(ascending: false));
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'asc',
                    child: Text('A \u2794 Z'),
                  ),
                  const PopupMenuItem(
                    value: 'desc',
                    child: Text('Z \u2794 A')
                  )
                ]
              );
            }
          ),
          ThemeToggleButton()
        ],
      ),
      body: BlocBuilder<FavoritesBloc, FavoritesState>(
        builder: (context, state) {
          if (state is FavoritesLoaded && state.favorites.isNotEmpty) {
            return GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 3 / 4
              ), 
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                final card = state.favorites[index];
                final isFavorite = state.favorites.any((c) => c.id == card.id);
                return CharacterCard(
                  model: card, 
                  isFavourite: isFavorite,
                  onTap: () {}, 
                  onIconPressed: () {
                    context.read<FavoritesBloc>().add(ToggleFavorite(card));
                  }
                );
              }
            );
          } else {
            return const Center(child: Text('Пока нет избранных персонажей'));
          }
        }
      ),
    );
  }
}