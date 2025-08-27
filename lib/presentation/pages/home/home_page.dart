import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rick_and_morty_app/core/theme/theme_cubit.dart';
import 'package:rick_and_morty_app/presentation/pages/favorites/favorites_bloc.dart';
import 'package:rick_and_morty_app/presentation/pages/favorites/favorites_event.dart';
import 'package:rick_and_morty_app/presentation/pages/favorites/favorites_state.dart';
import 'package:rick_and_morty_app/shared/widgets/character_card.dart';
import 'package:rick_and_morty_app/shared/widgets/theme_toggle_button.dart';
import 'home_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
  
}

class _HomePageState extends State<HomePage>{

  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(FetchCards());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        context.read<HomeBloc>().add(FetchNextPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Главная'),
          actions: [
            ThemeToggleButton()
          ],
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state){
            if (state is HomeLoaded && state.fromCache) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Нет соединения. Показаны сохраненные данные.'))
              );
            }
          },
          builder: (context, state) {
            if (state is HomeLoading) {
              return Center(child: CircularProgressIndicator());
            } else if(state is HomeLoaded) {
              return GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3 / 4
                  ), 
                itemCount: state.cards.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.cards.length) {
                    return state.hasReachedEnd ? const SizedBox.shrink() : const Center(child: CircularProgressIndicator(),);
                  }
                  final card = state.cards[index];
                  return CharacterCard(
                    model: card, 
                    isFavourite: context.watch<FavoritesBloc>().state is FavoritesLoaded &&
                    (context.watch<FavoritesBloc>().state as FavoritesLoaded)
                    .favorites
                    .any((c) => c.id == card.id),
                    onTap: () {},//при нажатии на карточку 
                    onIconPressed: () {
                      context.read<FavoritesBloc>().add(ToggleFavorite(card));
                    }//при нажатии на кнопку
                  );
                },
              );
            } else if (state is HomeError) {
              return Center(child: Text("Ошибка ${state.message}"));
            }
            return SizedBox.shrink();
          }
      ),
    );
  }
}
