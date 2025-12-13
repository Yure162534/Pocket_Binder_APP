class PocketSlot {
  String? cardId;
  bool isAcquired;

  PocketSlot({this.cardId, this.isAcquired = true});

  Map<String, dynamic> toJson() => {
        'cardId': cardId,
        'isAcquired': isAcquired,
      };

  static PocketSlot fromJson(Map<String, dynamic> json) {
    return PocketSlot(
      cardId: json['cardId'] as String?,
      // Default ke true jika field tidak ada (untuk data lama)
      isAcquired: json['isAcquired'] as bool? ?? true,
    );
  }
}
class Binder {
  String id;
  String name;
  int cols; // e.g., 2,3,4 meaning grid NxN
  int rows;
  int pages; // fixed 10
  List<List<PocketSlot>> slots; // pages * (rows*cols) storing card id or null

  Binder({
    required this.id,
    required this.name,
    required this.cols,
    required this.rows,
    required this.pages,
  }) : slots = List.generate(
            pages, (p) => List.generate(rows * cols, (_) => PocketSlot()));

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'cols': cols,
        'rows': rows,
        'pages': pages,
        'slots': slots.map((page) => page.map((slot) => slot.toJson()).toList()).toList(),
      };

  static Binder fromJson(Map<String, dynamic> j) {
    final b = Binder(id: j['id'], name: j['name'], cols: j['cols'], rows: j['rows'], pages: j['pages']);
    final raw = j['slots'] as List<dynamic>;
    b.slots = raw.map((page) => (page as List<dynamic>).map<PocketSlot>((slotData) => (slotData is String?) ? PocketSlot(cardId: slotData, isAcquired: slotData != null) : PocketSlot.fromJson(slotData as Map<String, dynamic>)).toList()).toList();
    return b;
  }
}