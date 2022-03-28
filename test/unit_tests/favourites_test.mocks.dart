// Mocks generated by Mockito 5.1.0 from annotations
// in veloplan/test/unit_tests/favourites_test.dart.
// Do not manually edit this file.

import 'dart:async' as _i4;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;
import 'package:veloplan/helpers/database_helpers/database_manager.dart' as _i3;
import 'package:veloplan/models/user.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

class _FakeCollectionReference_0<T extends Object?> extends _i1.Fake
    implements _i2.CollectionReference<T> {}

class _FakeQuerySnapshot_1<T extends Object?> extends _i1.Fake
    implements _i2.QuerySnapshot<T> {}

class _FakeDocumentSnapshot_2<T extends Object?> extends _i1.Fake
    implements _i2.DocumentSnapshot<T> {}

class _FakeFirebaseFirestore_3 extends _i1.Fake
    implements _i2.FirebaseFirestore {}

class _FakeDocumentReference_4<T extends Object?> extends _i1.Fake
    implements _i2.DocumentReference<T> {}

class _FakeQuery_5<T extends Object?> extends _i1.Fake implements _i2.Query<T> {
}

/// A class which mocks [DatabaseManager].
///
/// See the documentation for Mockito's code generation for more information.
class MockDatabaseManager extends _i1.Mock implements _i3.DatabaseManager {
  MockDatabaseManager() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CollectionReference<Object?> getUserSubCollectionReference(
          String? collectionName) =>
      (super.noSuchMethod(
          Invocation.method(#getUserSubCollectionReference, [collectionName]),
          returnValue:
              _FakeCollectionReference_0<Object?>()) as _i2
          .CollectionReference<Object?>);
  @override
  _i4.Future<_i2.QuerySnapshot<Object?>> getUserSubcollection(
          String? subcollection) =>
      (super.noSuchMethod(
              Invocation.method(#getUserSubcollection, [subcollection]),
              returnValue: Future<_i2.QuerySnapshot<Object?>>.value(
                  _FakeQuerySnapshot_1<Object?>()))
          as _i4.Future<_i2.QuerySnapshot<Object?>>);
  @override
  _i4.Future<dynamic> deleteCollection(
          _i2.CollectionReference<Object?>? collection) =>
      (super.noSuchMethod(Invocation.method(#deleteCollection, [collection]),
          returnValue: Future<dynamic>.value()) as _i4.Future<dynamic>);
  @override
  _i4.Future<void> deleteDocument(
          _i2.CollectionReference<Object?>? collection, String? documentId) =>
      (super.noSuchMethod(
          Invocation.method(#deleteDocument, [collection, documentId]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<_i2.QuerySnapshot<Map<String, dynamic>>> getByEquality(
          String? collection, String? field, String? equalTo) =>
      (super.noSuchMethod(
          Invocation.method(#getByEquality, [collection, field, equalTo]),
          returnValue: Future<_i2.QuerySnapshot<Map<String, dynamic>>>.value(
              _FakeQuerySnapshot_1<Map<String, dynamic>>())) as _i4
          .Future<_i2.QuerySnapshot<Map<String, dynamic>>>);
  @override
  _i4.Future<_i2.DocumentSnapshot<Map<String, dynamic>>> getByKey(
          String? collection, String? key) =>
      (super.noSuchMethod(Invocation.method(#getByKey, [collection, key]),
          returnValue: Future<_i2.DocumentSnapshot<Map<String, dynamic>>>.value(
              _FakeDocumentSnapshot_2<Map<String, dynamic>>())) as _i4
          .Future<_i2.DocumentSnapshot<Map<String, dynamic>>>);
  @override
  _i4.Future<void> setByKey(
          String? collection, String? key, Map<String, dynamic>? value,
          [_i2.SetOptions? options]) =>
      (super.noSuchMethod(
          Invocation.method(#setByKey, [collection, key, value, options]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> updateByKey(
          String? collection, String? key, Map<String, dynamic>? value) =>
      (super.noSuchMethod(
          Invocation.method(#updateByKey, [collection, key, value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> addToCollection(
          String? collection, Map<String, dynamic>? value) =>
      (super.noSuchMethod(
          Invocation.method(#addToCollection, [collection, value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> addToSubCollection(
          _i2.CollectionReference<Object?>? subcollection,
          Map<String, dynamic>? value) =>
      (super.noSuchMethod(
          Invocation.method(#addToSubCollection, [subcollection, value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> addSubCollectiontoSubCollectionByDocumentId(
          String? documentId,
          String? newSubollection,
          _i2.CollectionReference<Object?>? subcollection,
          Map<String, dynamic>? value) =>
      (super.noSuchMethod(
          Invocation.method(#addSubCollectiontoSubCollectionByDocumentId,
              [documentId, newSubollection, subcollection, value]),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
  @override
  _i4.Future<void> signOut() =>
      (super.noSuchMethod(Invocation.method(#signOut, []),
          returnValue: Future<void>.value(),
          returnValueForMissingStub: Future<void>.value()) as _i4.Future<void>);
}

/// A class which mocks [User].
///
/// See the documentation for Mockito's code generation for more information.
class MockUser extends _i1.Mock implements _i5.User {
  MockUser() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get imagePath =>
      (super.noSuchMethod(Invocation.getter(#imagePath), returnValue: '')
          as String);
  @override
  String get name =>
      (super.noSuchMethod(Invocation.getter(#name), returnValue: '') as String);
  @override
  String get email =>
      (super.noSuchMethod(Invocation.getter(#email), returnValue: '')
          as String);
  @override
  int get age =>
      (super.noSuchMethod(Invocation.getter(#age), returnValue: 0) as int);
}

/// A class which mocks [CollectionReference].
///
/// See the documentation for Mockito's code generation for more information.
// ignore: must_be_immutable
class MockCollectionReference<T extends Object?> extends _i1.Mock
    implements _i2.CollectionReference<T> {
  MockCollectionReference() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get id =>
      (super.noSuchMethod(Invocation.getter(#id), returnValue: '') as String);
  @override
  String get path =>
      (super.noSuchMethod(Invocation.getter(#path), returnValue: '') as String);
  @override
  _i2.FirebaseFirestore get firestore =>
      (super.noSuchMethod(Invocation.getter(#firestore),
          returnValue: _FakeFirebaseFirestore_3()) as _i2.FirebaseFirestore);
  @override
  Map<String, dynamic> get parameters =>
      (super.noSuchMethod(Invocation.getter(#parameters),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  _i4.Future<_i2.DocumentReference<T>> add(T? data) =>
      (super.noSuchMethod(Invocation.method(#add, [data]),
              returnValue: Future<_i2.DocumentReference<T>>.value(
                  _FakeDocumentReference_4<T>()))
          as _i4.Future<_i2.DocumentReference<T>>);
  @override
  _i2.DocumentReference<T> doc([String? path]) => (super.noSuchMethod(
      Invocation.method(#doc, [path]),
      returnValue: _FakeDocumentReference_4<T>()) as _i2.DocumentReference<T>);
  @override
  _i2.CollectionReference<R> withConverter<R extends Object?>(
          {_i2.FromFirestore<R>? fromFirestore,
          _i2.ToFirestore<R>? toFirestore}) =>
      (super.noSuchMethod(
              Invocation.method(#withConverter, [],
                  {#fromFirestore: fromFirestore, #toFirestore: toFirestore}),
              returnValue: _FakeCollectionReference_0<R>())
          as _i2.CollectionReference<R>);
  @override
  _i2.Query<T> endAtDocument(_i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(Invocation.method(#endAtDocument, [documentSnapshot]),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> endAt(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#endAt, [values]),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> endBeforeDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
          Invocation.method(#endBeforeDocument, [documentSnapshot]),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> endBefore(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#endBefore, [values]),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i4.Future<_i2.QuerySnapshot<T>> get([_i2.GetOptions? options]) =>
      (super.noSuchMethod(Invocation.method(#get, [options]),
              returnValue:
                  Future<_i2.QuerySnapshot<T>>.value(_FakeQuerySnapshot_1<T>()))
          as _i4.Future<_i2.QuerySnapshot<T>>);
  @override
  _i2.Query<T> limit(int? limit) =>
      (super.noSuchMethod(Invocation.method(#limit, [limit]),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> limitToLast(int? limit) =>
      (super.noSuchMethod(Invocation.method(#limitToLast, [limit]),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i4.Stream<_i2.QuerySnapshot<T>> snapshots(
          {bool? includeMetadataChanges = false}) =>
      (super.noSuchMethod(
              Invocation.method(#snapshots, [],
                  {#includeMetadataChanges: includeMetadataChanges}),
              returnValue: Stream<_i2.QuerySnapshot<T>>.empty())
          as _i4.Stream<_i2.QuerySnapshot<T>>);
  @override
  _i2.Query<T> orderBy(Object? field, {bool? descending = false}) =>
      (super.noSuchMethod(
          Invocation.method(#orderBy, [field], {#descending: descending}),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAfterDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
          Invocation.method(#startAfterDocument, [documentSnapshot]),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAfter(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#startAfter, [values]),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAtDocument(
          _i2.DocumentSnapshot<Object?>? documentSnapshot) =>
      (super.noSuchMethod(
          Invocation.method(#startAtDocument, [documentSnapshot]),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> startAt(List<Object?>? values) =>
      (super.noSuchMethod(Invocation.method(#startAt, [values]),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
  @override
  _i2.Query<T> where(Object? field,
          {Object? isEqualTo,
          Object? isNotEqualTo,
          Object? isLessThan,
          Object? isLessThanOrEqualTo,
          Object? isGreaterThan,
          Object? isGreaterThanOrEqualTo,
          Object? arrayContains,
          List<Object?>? arrayContainsAny,
          List<Object?>? whereIn,
          List<Object?>? whereNotIn,
          bool? isNull}) =>
      (super.noSuchMethod(
          Invocation.method(#where, [
            field
          ], {
            #isEqualTo: isEqualTo,
            #isNotEqualTo: isNotEqualTo,
            #isLessThan: isLessThan,
            #isLessThanOrEqualTo: isLessThanOrEqualTo,
            #isGreaterThan: isGreaterThan,
            #isGreaterThanOrEqualTo: isGreaterThanOrEqualTo,
            #arrayContains: arrayContains,
            #arrayContainsAny: arrayContainsAny,
            #whereIn: whereIn,
            #whereNotIn: whereNotIn,
            #isNull: isNull
          }),
          returnValue: _FakeQuery_5<T>()) as _i2.Query<T>);
}
