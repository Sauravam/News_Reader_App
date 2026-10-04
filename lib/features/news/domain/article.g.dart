// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'article.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Article _$ArticleFromJson(Map<String, dynamic> json) => _Article(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  url: json['url'] as String,
  imageUrl: json['image_url'] as String?,
  newsSite: json['news_site'] as String?,
  summary: json['summary'] as String?,
  publishedAt: json['published_at'] as String?,
);

Map<String, dynamic> _$ArticleToJson(_Article instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'url': instance.url,
  'image_url': instance.imageUrl,
  'news_site': instance.newsSite,
  'summary': instance.summary,
  'published_at': instance.publishedAt,
};
