import 'package:binder_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class CreateBinderSheet extends StatefulWidget {
  final Function(String name, int size, int pages) onCreate;
  const CreateBinderSheet({super.key, required this.onCreate});

  @override
  _CreateBinderSheetState createState() => _CreateBinderSheetState();
}

class _CreateBinderSheetState extends State<CreateBinderSheet> {
  final _nameController = TextEditingController();
  final _pagesController = TextEditingController(text: '10');

  @override
  void dispose() {
    _nameController.dispose();
    _pagesController.dispose();
    super.dispose();
  }

  void _handleCreate(int size, AppLocalizations l10n) {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.binderNameCannotBeEmpty)));
      return;
    }
    final pages = int.tryParse(_pagesController.text) ?? 10;
    Navigator.pop(context);
    widget.onCreate(name, size, pages);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const textColor = Color(0xFFE5E5E5);
    final hintColor = textColor.withOpacity(0.6);

    return SafeArea(
      child: SingleChildScrollView( // Gunakan SingleChildScrollView untuk menghindari overflow jika keyboard muncul
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            runSpacing: 12,
            children: [
              Text(l10n.newBinder, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: textColor)),
              TextField(
                controller: _nameController,
                style: const TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: l10n.binderName,
                  labelStyle: TextStyle(color: hintColor),
                  hintText: l10n.exampleRareCollection,
                  hintStyle: TextStyle(color: hintColor.withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: hintColor)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: textColor)),
                ),
              ),
              TextField(
                controller: _pagesController,
                style: const TextStyle(color: textColor),
                decoration: InputDecoration(
                  labelText: l10n.totalPage,
                  labelStyle: TextStyle(color: hintColor),
                  hintText: 'Contoh: 10',
                  hintStyle: TextStyle(color: hintColor.withOpacity(0.5)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: hintColor)),
                  focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: textColor)),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              Text(l10n.pocketStyle, style: const TextStyle(color: textColor)),
              Material(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: textColor)),
                child: ListTile(leading: const Icon(Icons.grid_on, color: textColor), title: const Text('2 x 2', style: TextStyle(color: textColor)), onTap: () => _handleCreate(2, l10n), splashColor: Colors.white.withOpacity(0.3)),
              ),
              Material(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: textColor)),
                child: ListTile(leading: const Icon(Icons.grid_on, color: textColor), title: const Text('3 x 3', style: TextStyle(color: textColor)), onTap: () => _handleCreate(3, l10n), splashColor: Colors.white.withOpacity(0.3)),
              ),
              Material(
                color: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: const BorderSide(color: textColor)),
                child: ListTile(leading: const Icon(Icons.grid_on, color: textColor), title: const Text('4 x 4', style: TextStyle(color: textColor)), onTap: () => _handleCreate(4, l10n), splashColor: Colors.white.withOpacity(0.3)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}