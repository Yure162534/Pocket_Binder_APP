import 'package:binder_app/data/db.dart';
import 'package:binder_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class CardPickerSheet extends StatefulWidget {
  final String? selectedCardId;
  const CardPickerSheet({super.key, this.selectedCardId});

  @override
  _CardPickerSheetState createState() => _CardPickerSheetState();
}

class _CardPickerSheetState extends State<CardPickerSheet> {
  String? chosen;
  String query = '';
  Future<List<CardModel>>? _cardsFuture;

  @override
  void initState() {
    super.initState();
    chosen = widget.selectedCardId;
    _cardsFuture = cardService.getAllCards(); // Panggil sekali di initState
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const primaryColor = Color(0xFF1E1E2A);
    const textColor = Color(0xFFE5E5E5);
    final hintColor = textColor.withOpacity(0.6);

    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(l10n.pickACard, style: const TextStyle(color: textColor)),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text(l10n.cancel, style: const TextStyle(color: textColor)),
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              style: const TextStyle(color: textColor),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: hintColor),
                hintText: l10n.searchCard,
                hintStyle: TextStyle(color: hintColor),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: hintColor)),
                focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: textColor)),
              ),
              onChanged: (v) => setState(() => query = v),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<CardModel>>(
                future: _cardsFuture, // Gunakan future dari state
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.hasError) {
                    // Tampilkan pesan error yang lebih detail untuk debugging
                    final errorText = snapshot.error?.toString() ?? l10n.pickACard; // Fallback text
                    return Center(child: Text('Gagal memuat data kartu:\n$errorText', textAlign: TextAlign.center, style: const TextStyle(color: textColor)));
                  }

                  final allCards = snapshot.data!;
                  final filtered = allCards.where((c) => c.title.toLowerCase().contains(query.toLowerCase())).toList();

                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.75),
                    itemCount: filtered.length,
                    itemBuilder: (c, i) {
                      final card = filtered[i];
                      final isSelected = chosen == card.id;
                      return GestureDetector(
                        onTap: () => setState(() => chosen = card.id),
                        onDoubleTap: () => Navigator.pop(context, card.id),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFF233447),
                            border: Border.all(color: isSelected ? const Color(0xFF0E86AD) : Colors.grey.shade700, width: isSelected ? 2.5 : 1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Image.network(
                                    card.imageUrl, // Menggunakan imageUrl yang konsisten
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.error))),
                                ),
                                const SizedBox(height: 4),
                                Text(card.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: textColor)),
                                Text(card.subtitle, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              children: [Expanded(
                child: Builder(builder: (context) {
                  final isCardSelected = chosen != null;
                  return ElevatedButton(
                    style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) => states.contains(WidgetState.disabled) ? const Color(0xFF085A73) : const Color(0xFF0A6D8C)), foregroundColor: WidgetStateProperty.all(textColor), padding: WidgetStateProperty.all(const EdgeInsets.symmetric(vertical: 12)), shape: WidgetStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), side: WidgetStateProperty.all(isCardSelected ? const BorderSide(color: Color(0xFF0E86AD), width: 2) : BorderSide.none)),
                    // Tombol akan non-aktif jika 'chosen' adalah null.
                    onPressed: isCardSelected ? () => Navigator.pop(context, chosen) : null,
                    child: Text(l10n.select, style: const TextStyle(fontSize: 16)),
                  );
                }),
              )],
            ),
          )
        ],
      ),
    );
  }
}