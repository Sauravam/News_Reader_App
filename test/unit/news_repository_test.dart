import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:newspulse/core/error/failures.dart';
import 'package:newspulse/features/news/data/news_remote_data_source.dart';
import 'package:newspulse/features/news/data/news_repository_impl.dart';

class MockNewsRemoteDataSource extends Mock implements NewsRemoteDataSource {}

void main() {
  late MockNewsRemoteDataSource mockRemoteDataSource;
  late NewsRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockNewsRemoteDataSource();
    repository = NewsRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('NewsRepositoryImpl', () {
    final sampleResponse = {
      'count': 1,
      'next': null,
      'previous': null,
      'results': [
        {
          'id': 101,
          'title': 'Test Article',
          'url': 'https://example.com/test',
          'image_url': 'https://example.com/img.jpg',
          'news_site': 'NASA',
          'summary': 'Summary text',
          'published_at': '2026-10-03T10:00:00Z',
        }
      ],
    };

    test('returns Result.success with NewsPage when remote call succeeds', () async {
      when(() => mockRemoteDataSource.getArticles(
            limit: 10,
            offset: 0,
            search: null,
            cancelToken: any(named: 'cancelToken'),
          )).thenAnswer((_) async => sampleResponse);

      final result = await repository.getArticles(limit: 10, offset: 0);

      expect(result.isSuccess, isTrue);
      final page = result.dataOrNull!;
      expect(page.items.length, 1);
      expect(page.items.first.title, 'Test Article');
      expect(page.hasMore, isFalse);
      expect(page.total, 1);
    });

    test('returns Result.err(Failure.noInternet()) when Dio connection error occurs', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/articles/'),
        type: DioExceptionType.connectionError,
      );

      when(() => mockRemoteDataSource.getArticles(
            limit: 10,
            offset: 0,
            search: null,
            cancelToken: any(named: 'cancelToken'),
          )).thenThrow(dioException);

      final result = await repository.getArticles(limit: 10, offset: 0);

      expect(result.isErr, isTrue);
      expect(result.failureOrNull, const Failure.noInternet());
    });
  });
}
