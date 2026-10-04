// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'news_feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$NewsFeedState {

 NewsFeedStatus get status; List<Article> get items; bool get isLoadingMore; bool get hasMore; int get totalResults; Failure? get failure; Failure? get paginationFailure; String get query;
/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewsFeedStateCopyWith<NewsFeedState> get copyWith => _$NewsFeedStateCopyWithImpl<NewsFeedState>(this as NewsFeedState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewsFeedState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.paginationFailure, paginationFailure) || other.paginationFailure == paginationFailure)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(items),isLoadingMore,hasMore,totalResults,failure,paginationFailure,query);

@override
String toString() {
  return 'NewsFeedState(status: $status, items: $items, isLoadingMore: $isLoadingMore, hasMore: $hasMore, totalResults: $totalResults, failure: $failure, paginationFailure: $paginationFailure, query: $query)';
}


}

/// @nodoc
abstract mixin class $NewsFeedStateCopyWith<$Res>  {
  factory $NewsFeedStateCopyWith(NewsFeedState value, $Res Function(NewsFeedState) _then) = _$NewsFeedStateCopyWithImpl;
@useResult
$Res call({
 NewsFeedStatus status, List<Article> items, bool isLoadingMore, bool hasMore, int totalResults, Failure? failure, Failure? paginationFailure, String query
});


$FailureCopyWith<$Res>? get failure;$FailureCopyWith<$Res>? get paginationFailure;

}
/// @nodoc
class _$NewsFeedStateCopyWithImpl<$Res>
    implements $NewsFeedStateCopyWith<$Res> {
  _$NewsFeedStateCopyWithImpl(this._self, this._then);

  final NewsFeedState _self;
  final $Res Function(NewsFeedState) _then;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? items = null,Object? isLoadingMore = null,Object? hasMore = null,Object? totalResults = null,Object? failure = freezed,Object? paginationFailure = freezed,Object? query = null,}) {
  return _then(NewsFeedState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NewsFeedStatus,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<Article>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,paginationFailure: freezed == paginationFailure ? _self.paginationFailure : paginationFailure // ignore: cast_nullable_to_non_nullable
as Failure?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get paginationFailure {
    if (_self.paginationFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.paginationFailure!, (value) {
    return _then(_self.copyWith(paginationFailure: value));
  });
}
}


/// Adds pattern-matching-related methods to [NewsFeedState].
extension NewsFeedStatePatterns on NewsFeedState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewsFeedState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewsFeedState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewsFeedState value)  $default,){
final _that = this;
switch (_that) {
case _NewsFeedState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewsFeedState value)?  $default,){
final _that = this;
switch (_that) {
case _NewsFeedState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( NewsFeedStatus status,  List<Article> items,  bool isLoadingMore,  bool hasMore,  int totalResults,  Failure? failure,  Failure? paginationFailure,  String query)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewsFeedState() when $default != null:
return $default(_that.status,_that.items,_that.isLoadingMore,_that.hasMore,_that.totalResults,_that.failure,_that.paginationFailure,_that.query);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( NewsFeedStatus status,  List<Article> items,  bool isLoadingMore,  bool hasMore,  int totalResults,  Failure? failure,  Failure? paginationFailure,  String query)  $default,) {final _that = this;
switch (_that) {
case _NewsFeedState():
return $default(_that.status,_that.items,_that.isLoadingMore,_that.hasMore,_that.totalResults,_that.failure,_that.paginationFailure,_that.query);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( NewsFeedStatus status,  List<Article> items,  bool isLoadingMore,  bool hasMore,  int totalResults,  Failure? failure,  Failure? paginationFailure,  String query)?  $default,) {final _that = this;
switch (_that) {
case _NewsFeedState() when $default != null:
return $default(_that.status,_that.items,_that.isLoadingMore,_that.hasMore,_that.totalResults,_that.failure,_that.paginationFailure,_that.query);case _:
  return null;

}
}

}

/// @nodoc


class _NewsFeedState implements NewsFeedState {
  const _NewsFeedState({this.status = NewsFeedStatus.initial,  List<Article> items = const [], this.isLoadingMore = false, this.hasMore = true, this.totalResults = 0, this.failure, this.paginationFailure, this.query = ''}): _items = items;
  

@override@JsonKey() final  NewsFeedStatus status;
 final  List<Article> _items;
@override@JsonKey() List<Article> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  int totalResults;
@override final  Failure? failure;
@override final  Failure? paginationFailure;
@override@JsonKey() final  String query;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewsFeedStateCopyWith<_NewsFeedState> get copyWith => __$NewsFeedStateCopyWithImpl<_NewsFeedState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewsFeedState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.totalResults, totalResults) || other.totalResults == totalResults)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.paginationFailure, paginationFailure) || other.paginationFailure == paginationFailure)&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_items),isLoadingMore,hasMore,totalResults,failure,paginationFailure,query);

@override
String toString() {
  return 'NewsFeedState(status: $status, items: $items, isLoadingMore: $isLoadingMore, hasMore: $hasMore, totalResults: $totalResults, failure: $failure, paginationFailure: $paginationFailure, query: $query)';
}


}

/// @nodoc
abstract mixin class _$NewsFeedStateCopyWith<$Res> implements $NewsFeedStateCopyWith<$Res> {
  factory _$NewsFeedStateCopyWith(_NewsFeedState value, $Res Function(_NewsFeedState) _then) = __$NewsFeedStateCopyWithImpl;
@override @useResult
$Res call({
 NewsFeedStatus status, List<Article> items, bool isLoadingMore, bool hasMore, int totalResults, Failure? failure, Failure? paginationFailure, String query
});


@override $FailureCopyWith<$Res>? get failure;@override $FailureCopyWith<$Res>? get paginationFailure;

}
/// @nodoc
class __$NewsFeedStateCopyWithImpl<$Res>
    implements _$NewsFeedStateCopyWith<$Res> {
  __$NewsFeedStateCopyWithImpl(this._self, this._then);

  final _NewsFeedState _self;
  final $Res Function(_NewsFeedState) _then;

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? items = null,Object? isLoadingMore = null,Object? hasMore = null,Object? totalResults = null,Object? failure = freezed,Object? paginationFailure = freezed,Object? query = null,}) {
  return _then(_NewsFeedState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as NewsFeedStatus,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<Article>,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,totalResults: null == totalResults ? _self.totalResults : totalResults // ignore: cast_nullable_to_non_nullable
as int,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,paginationFailure: freezed == paginationFailure ? _self.paginationFailure : paginationFailure // ignore: cast_nullable_to_non_nullable
as Failure?,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}/// Create a copy of NewsFeedState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get paginationFailure {
    if (_self.paginationFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.paginationFailure!, (value) {
    return _then(_self.copyWith(paginationFailure: value));
  });
}
}

// dart format on
