import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'api_client.dart';
import 'models/card_model.dart';

class RepositoryResult {
  final List<CardModel> cards;
  final bool fromCache;
  RepositoryResult(this.cards ,{this.fromCache = false});
}

class CardRepository {
  final ApiClient apiClient;
  final Box<CardModel> box;
  CardRepository({required this.apiClient, required this.box});

  Future<RepositoryResult> getCards({int page = 1, count = 20}) async {

    try {
      final response = await apiClient.getCardsRaw(page, count);

      final raw = response.data as Map<String, dynamic>;

      
      final List<dynamic> results = raw['results'] ?? [];
      for (var e in results) {
        final card = CardModel.fromJson(e);

        final existing = box.get(card.id);
        if (existing != null) {
          card.isFavorite = existing.isFavorite;
        }

        await box.put(card.id, card);
      }

      return RepositoryResult(box.values.toList(), fromCache: false);
    } on DioException catch(e) {
      print('No interner or API error');
      return RepositoryResult(box.values.toList(), fromCache: true);
    }
    catch (e) {
      print('Неизвестная ошибка $e');
      return RepositoryResult(box.values.toList(), fromCache: true);
    }
  }

  Future<void> ToggleFavorite(CardModel card) async {
    card.isFavorite = !card.isFavorite;
    await card.save();
  }

  List<CardModel> getFavorites() {
    return box.values.where((c) => c.isFavorite).toList();
  }

  Future<CardModel> getCardDetails(int id) async {
    final response = await apiClient.getCardDetailsRaw(id);
    final data = response.data as Map<String, dynamic>;
    return CardModel.fromJson(data);
  }
}