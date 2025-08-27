import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/shared/widgets/favorite_button.dart';
import '../../data/models/card_model.dart';

class CharacterCard extends StatelessWidget {
  final CardModel model;
  final VoidCallback onTap;
  final VoidCallback onIconPressed;
  final bool isFavourite;

  const CharacterCard({
    super.key,
    required this.model,
    required this.onTap,
    required this.onIconPressed,
    this.isFavourite = false
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(12)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: model.image != null && model.image.isNotEmpty
                ? CachedNetworkImage(
                  imageUrl: model.image,
                  fit: BoxFit.cover,
                  placeholder: (context, _) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                  errorWidget: (context, _, __) => const Icon(Icons.broken_image),
                )
                : Container(
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, size: 50, color: Colors.grey),
                )
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                model.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                model.species,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FavoriteButton(card: model, isFavorite: model.isFavorite)
              ],
            )
          ],
        ),
      ),
    );
  }
}