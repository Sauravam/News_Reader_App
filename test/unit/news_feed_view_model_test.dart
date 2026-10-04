import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:newspulse/core/error/failures.dart';
import 'package:newspulse/core/utils/result.dart';
import 'package:newspulse/features/news/domain/article.dart';
import 'package:newspulse/features/news/domain/news_page.dart';
import 'package:newspulse/features/news/domain/news_repository.dart';
import 'package:newspulse/features/news/presentation/news_feed_state.dart';
import 'package:newspulse/features/news/presentation/news_feed_view_model.dart';

class MockNewsRepository extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepository mockNewsRepository;
  late NewsFeedViewModel viewModel;

  const article1 = Article(id: 1, title: 'Article 1', url: 'https://a.com/1');
  const article2 = Article(id: 2, title: 'Article 2', url: 'https://a.com/2');

  setUp(() {
    mockNewsRepository = MockNewsRepository();
  });

  group('NewsFeedViewModel', () {
    test('fetches initial feed successfully', () async {
      when(() => mockNewsRepository.getArticles(
            limit: 10,
            offset: 0,
            search: '',
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => Result.success(
            const NewsPage(items: [article1, article2], hasMore: true, total: 20),
          ));

      viewModel = NewsFeedViewModel(newsRepository: mockNewsRepository);
      await Future.microtask(() {});

      expect(viewModel.state.status, NewsFeedStatus.success);
      expect(viewModel.state.items.length, 2);
      expect(viewModel.state.hasMore, isTrue);
    });

    test('sets status to empty when initial fetch returns 0 items', () async {
      when(() => mockNewsRepository.getArticles(
            limit: 10,
            offset: 0,
            search: '',
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => Result.success(
            const NewsPage(items: [], hasMore: false, total: 0),
          ));

      viewModel = NewsFeedViewModel(newsRepository: mockNewsRepository);
      await Future.microtask(() {});

      expect(viewModel.state.status, NewsFeedStatus.empty);
      expect(viewModel.state.items, isEmpty);
    });

    test('sets status to error when initial fetch fails', () async {
      when(() => mockNewsRepository.getArticles(
            limit: 10,
            offset: 0,
            search: '',
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => Result.err(const Failure.noInternet()));

      viewModel = NewsFeedViewModel(newsRepository: mockNewsRepository);
      await Future.microtask(() {});

      expect(viewModel.state.status, NewsFeedStatus.error);
      expect(viewModel.state.failure, const Failure.noInternet());
    });

    test('fetches next page and dedupes items', () async {
      when(() => mockNewsRepository.getArticles(
            limit: 10,
            offset: 0,
            search: '',
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => Result.success(
            const NewsPage(items: [article1], hasMore: true, total: 2),
          ));

      viewModel = NewsFeedViewModel(newsRepository: mockNewsRepository);
      await Future.microtask(() {});

      when(() => mockNewsRepository.getArticles(
            limit: 10,
            offset: 1,
            search: '',
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => Result.success(
            const NewsPage(items: [article2], hasMore: false, total: 2),
          ));

      await viewModel.fetchNextPage();

      expect(viewModel.state.items.length, 2);
      expect(viewModel.state.hasMore, isFalse);
    });

    test('debounces search queries by 400ms using fakeAsync', () {
      fakeAsync((async) {
        when(() => mockNewsRepository.getArticles(
              limit: 10,
              offset: 0,
              search: any(named: 'search'),
              cancelToken: any(named: 'cancelToken'),
            )).thenAnswer((_) async => Result.success(
              const NewsPage(items: [article1], hasMore: false, total: 1),
            ));

        viewModel = NewsFeedViewModel(newsRepository: mockNewsRepository);
        async.flushMicrotasks();

        viewModel.onSearchQueryChanged('Space');
        expect(viewModel.state.query, 'Space');

        // Advance 200ms - query shouldn't trigger network call yet
        async.elapse(const Duration(milliseconds: 200));

        // Advance remaining 250ms - debouncer fires
        async.elapse(const Duration(milliseconds: 250));
        async.flushMicrotasks();

        verify(() => mockNewsRepository.getArticles(
              limit: 10,
              offset: 0,
              search: 'Space',
              cancelToken: any(named: 'cancelToken'),
            )).called(1);
      });
    });
  });
}
