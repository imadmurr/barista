import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/cocktail.dart';
import '../models/ingredient.dart';

class CocktailsRepository {
  CocktailsRepository._();

  static final instance = CocktailsRepository._();

  final _db = FirebaseFirestore.instance;
  final _collection = 'cocktails';

  /// Discover screen: random-ish cocktails
  Stream<List<Cocktail>> watchDiscover({int limit = 20}) {
    return _db
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  Stream<List<Cocktail>> watchAllForSearch({int limit = 250}) {
    return _db
        .collection(_collection)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map((snap) => snap.docs.map(_fromDoc).toList());
  }

  Stream<List<Cocktail>> watchByIds(Set<String> ids) {
    if (ids.isEmpty) return Stream.value(const <Cocktail>[]);

    final idList = ids.toList();
    final chunks = <List<String>>[];

    for (var i = 0; i < idList.length; i += 10) {
      chunks.add(
        idList.sublist(i, i + 10 > idList.length ? idList.length : i + 10),
      );
    }

    final streams = chunks.map((chunk) {
      return _db
          .collection(_collection)
          .where('id', whereIn: chunk)
          .snapshots()
          .map((snap) => snap.docs.map(_fromDoc).toList());
    }).toList();

    // Merge chunk streams into one list
    return Stream<List<Cocktail>>.multi((controller) {
      final all = List<List<Cocktail>>.filled(
        streams.length,
        const <Cocktail>[],
        growable: false,
      );
      final subs = <StreamSubscription>[];

      void emit() {
        final merged = <Cocktail>[];
        for (final part in all) {
          merged.addAll(part);
        }

        // Keep order stable according to favorites order (optional):
        final order = {for (var i = 0; i < idList.length; i++) idList[i]: i};
        merged.sort(
          (a, b) => (order[a.id] ?? 999999).compareTo(order[b.id] ?? 999999),
        );

        controller.add(merged);
      }

      for (var i = 0; i < streams.length; i++) {
        final sub = streams[i].listen((items) {
          all[i] = items;
          emit();
        }, onError: controller.addError);
        subs.add(sub);
      }

      controller.onCancel = () async {
        for (final s in subs) {
          await s.cancel();
        }
      };
    });
  }

  /// Cocktail detail
  Future<Cocktail?> getById(String id) async {
    final doc = await _db.collection(_collection).doc(id).get();
    if (!doc.exists) return null;
    return _fromDoc(doc);
  }

  // ------------------------
  // Mapping
  // ------------------------

  Cocktail _fromDoc(DocumentSnapshot doc) {
    final data = doc.data()! as Map<String, dynamic>;

    return Cocktail(
      id: data['id'],
      name: data['name'],
      subtitle: data['subtitle'],
      tags: List<String>.from(data['tags']),
      steps: List<String>.from(data['steps']),
      gradient: (data['gradient'] as List).cast<int>().map(Color.new).toList(),
      layerColors: (data['layerColors'] as List)
          .cast<int>()
          .map(Color.new)
          .toList(),
      ingredients: (data['ingredients'] as List)
          .map((e) => Ingredient(amount: e['amount'], name: e['name']))
          .toList(),
    );
  }
}
