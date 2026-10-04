import 'package:flutter_test/flutter_test.dart';
import 'package:newspulse/features/news/data/article_model.dart';

void main() {
  group('ArticleModel Parsing', () {
    final validJson = {
      'id': 101,
      'title': 'SpaceX Starship Launch',
      'url': 'https://spacex.com/news/1',
      'image_url': 'https://spacex.com/img.jpg',
      'news_site': 'SpaceX',
      'summary': 'Starship rocket test flight successful.',
      'published_at': '2026-10-03T12:00:00Z',
    };

    test('parses valid article json successfully', () {
      final model = ArticleModel.fromJson(validJson);
      expect(model.id, 101);
      expect(model.title, 'SpaceX Starship Launch');
      expect(model.url, 'https://spacex.com/news/1');
      expect(model.imageUrl, 'https://spacex.com/img.jpg');
      expect(model.newsSite, 'SpaceX');
    });

    test('safeFromJson returns null if required field is missing', () {
      final missingTitle = {
        'id': 101,
        'url': 'https://spacex.com/news/1',
      };
      expect(ArticleModel.safeFromJson(missingTitle), isNull);
    });

    test('safeFromJson parses item with missing optional fields', () {
      final missingOptionals = {
        'id': 102,
        'title': 'Minimal Article',
        'url': 'https://example.com/min',
      };
      final model = ArticleModel.safeFromJson(missingOptionals);
      expect(model, isNotNull);
      expect(model!.id, 102);
      expect(model.imageUrl, isNull);
      expect(model.summary, isNull);
    });

    test('toDomain converts ArticleModel to Article entity', () {
      final model = ArticleModel.fromJson(validJson);
      final domain = model.toDomain();
      expect(domain.id, model.id);
      expect(domain.title, model.title);
      expect(domain.url, model.url);
      expect(domain.imageUrl, model.imageUrl);
      expect(domain.newsSite, model.newsSite);
    });
  });
}
