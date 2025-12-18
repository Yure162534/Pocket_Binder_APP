import 'package:binder_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatefulWidget {
  final Set<String> initialFilters;
  final AppLocalizations l10n;

  const FilterDialog({super.key, required this.initialFilters, required this.l10n});
  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  late Set<String> _selectedFilters;

  // Daftar semua opsi filter yang tersedia
  final List<String> _filterOptions = const [
    "PSE", "QCSE", "HR", "CR", "SE", "UL", "UR", "SR", "R", "NP", "N"
  ];

  @override
  void initState() {
    super.initState();
    // Buat salinan dari filter awal agar bisa diubah tanpa mempengaruhi state sebelumnya
    _selectedFilters = {...widget.initialFilters};
  }

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFFE5E5E5);
    const activeColor = Color(0xFF0A6D8C);
    const inactiveColor = Color(0xFF262A36);

    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E2A),
      title: Text('Filter by Rarity', style: const TextStyle(color: textColor)),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 8.0, // Jarak horizontal antar chip
          runSpacing: 8.0, // Jarak vertikal antar baris chip
          children: _filterOptions.map((rarity) {
            final isSelected = _selectedFilters.contains(rarity);
            return FilterChip(
              label: Text(rarity),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedFilters.add(rarity);
                  } else {
                    _selectedFilters.remove(rarity);
                  }
                });
              },
              labelStyle: TextStyle(
                color: isSelected ? textColor : textColor.withOpacity(0.8),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
              backgroundColor: inactiveColor,
              selectedColor: activeColor,
              checkmarkColor: textColor,
              shape: StadiumBorder(
                side: BorderSide(
                  color: isSelected ? const Color(0xFF0E86AD) : Colors.grey.shade600,
                ),
              ),
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        // Tombol untuk menghapus semua filter
        if (_selectedFilters.isNotEmpty)
          TextButton(
            child: Text('Clear All', style: TextStyle(color: Colors.amber.shade600)),
            onPressed: () {
              setState(() {
                _selectedFilters.clear();
              });
            },
          ),
        const Spacer(),
        // Tombol Batal
        TextButton(
          child: Text(widget.l10n.cancel, style: const TextStyle(color: textColor)),
          onPressed: () => Navigator.of(context).pop(), // Tutup dialog tanpa mengembalikan data
        ),
        // Tombol Terapkan
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: activeColor, foregroundColor: textColor),
          child: Text(widget.l10n.save), // Menggunakan 'save' dari l10n
          onPressed: () => Navigator.of(context).pop(_selectedFilters), // Tutup dialog dan kembalikan filter yang dipilih
        ),
      ],
    );
  }
}