import 'package:supabase_flutter/supabase_flutter.dart';

/// Model untuk data kartu.
/// Pastikan field di sini cocok dengan nama kolom di tabel Supabase Anda.
class CardModel {
  final String id;
  final String title; // Jika bisa null di DB, ganti jadi String?
  final String subtitle; // Jika bisa null di DB, ganti jadi String?
  final String imageUrl; // Jika bisa null di DB, ganti jadi String?

  CardModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  /// Membuat instance CardModel dari map (data JSON dari Supabase).
  factory CardModel.fromJson(Map<String, dynamic> json) {
    try {
      return CardModel(
        // Berikan nilai default jika null untuk menghindari error
        id: json['id'] as String? ?? 'no-id',
        title: json['title'] as String? ?? 'No Title',
        subtitle: json['subtitle'] as String? ?? '',
        imageUrl: json['imageUrl'] as String? ?? '',
      );
    } catch (e) {
      // Jika terjadi error saat parsing, cetak error dan data JSON yang bermasalah
      print('Error parsing CardModel from JSON: $e');
      print('Problematic JSON: $json');
      rethrow; // Lempar kembali error agar bisa ditangani
    }
  }
}

/// Service untuk berinteraksi dengan tabel 'cards' di Supabase.
class CardDatabaseService {
  // Membuat instance singleton dari Supabase client.
  final _supabase = Supabase.instance.client;

  // Membuat instance singleton dari service ini.
  CardDatabaseService._privateConstructor();
  static final CardDatabaseService instance =
      CardDatabaseService._privateConstructor();

  /// Mengambil semua data kartu dari tabel 'cards'.
  Future<List<CardModel>> getAllCards() async {
    try {
      // Implementasi Pagination untuk mengambil lebih dari 1000 baris
      final List<CardModel> allCards = [];
      const int pageSize = 500; // Ambil 500 baris per permintaan
      int page = 0;

      while (true) {
        final int from = page * pageSize;
        final int to = from + pageSize - 1;

        final response = await _supabase
            .from('AEDatabase')
            .select()
            .range(from, to);

        final cardsOnPage = response.map((item) => CardModel.fromJson(item)).toList();
        allCards.addAll(cardsOnPage);

        // Jika data yang kembali lebih sedikit dari yang diminta, berarti ini halaman terakhir
        if (cardsOnPage.length < pageSize) {
          break;
        }
        page++;
      }
      return allCards;
    } catch (e) {
      // Menangani error, misalnya dengan mencetak ke konsol.
      print('Error fetching cards: $e');
      return [];
    }
  }
}

// Inisialisasi service database kita.
// Ini bisa diakses dari mana saja di dalam aplikasi (sebagai singleton).
final cardService = CardDatabaseService.instance;