import 'package:flutter/material.dart';
import '../../../../data/models/card_model.dart';

class HomeList extends StatelessWidget{
  final List<CardModel> cards;
  const HomeList({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: cards.length,
      itemBuilder: (_, index) {
        final card = cards[index];
        return ListTile(
          title: Text(card.name),
          subtitle: Text(card.species),
          onTap: () => {},//сделать Navigator.push на страничку персонажа
        );
      }
      );
  }
}