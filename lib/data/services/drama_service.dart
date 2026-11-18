import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DramaService {
  Future<List> fetchRawDramas();
  Future<void> saveRawDramas(List rawDramas);
}

class LocalDramaService implements DramaService {
  static const String _storageKey = 'dramas_vault_storage_v1';

  @override
  Future<List> fetchRawDramas() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_storageKey);

    if (jsonString == null) {
      jsonString = await rootBundle.loadString('assets/dramas.json');
      await prefs.setString(_storageKey, jsonString);
    }

    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.cast();
  }

  @override
  Future<void> saveRawDramas(List rawDramas) async {
  final prefs = await SharedPreferences.getInstance();
  final String updatedJsonString = json.encode(rawDramas);
  await prefs.setString(_storageKey, updatedJsonString);
  }
}

class FakeRemoteDramaService implements DramaService {
  final List _cloudDatabase = [
  {
  'id': 'API-101',
  'title': 'Queen of Tears (Cloud API)',
  'genre': 'Romance, Drama',
  'totalEpisodes': 16,
  'watchedEpisodes': 2,
  'rating': 4.8,
  'origin': 'K-Drama',
  'synopsis':
  'Kisah pernikahan pewaris konglomerat dan pengacara desa yang menghadapi krisis besar.',
  'tags': ['Marriage', 'Chaebol', 'Melodrama'],
  'imageUrl': '',
  'isBookmarked': true,
  },
  {
  'id': 'API-102',
  'title': 'Alchemy of Souls (Cloud API)',
  'genre': 'Fantasy, Action',
  'totalEpisodes': 20,
  'watchedEpisodes': 0,
  'rating': 4.9,
  'origin': 'K-Drama',
  'synopsis':
  'Penyihir tangguh terjebak dalam tubuh pelayan lemah di negara fiksi Daeho.',
  'tags': ['Magic', 'Swordplay', 'Historical'],
  'imageUrl': '',
  'isBookmarked': false,
  },
  ];

  @override
  Future<List> fetchRawDramas() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_cloudDatabase);
  }

  @override
  Future<void> saveRawDramas(List rawDramas) async {
  await Future.delayed(const Duration(milliseconds: 300));
  _cloudDatabase
  ..clear()
  ..addAll(rawDramas);
  }
}