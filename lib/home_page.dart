import 'dart:convert';

import 'package:binder_app/l10n/app_localizations.dart';
import 'package:binder_app/main.dart' show BinderApp;
import 'package:binder_app/binder_models.dart';
import 'package:binder_app/binder_view.dart';
import 'package:binder_app/create_binder_sheet.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Binder> binders = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBinders();
  }

  Future<void> loadBinders() async {
    setState(() => loading = true);
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('binders_json');
    if (s != null) {
      final decoded = jsonDecode(s) as List<dynamic>;
      binders = decoded.map((e) => Binder.fromJson(e)).toList();
    }
    setState(() => loading = false);
  }

  Future<void> saveBinders() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(binders.map((b) => b.toJson()).toList());
    await prefs.setString('binders_json', encoded);
  }

  void createBinder(String name, int size, int pages) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final binderName = name.isNotEmpty ? name : 'Binder ${binders.length + 1} (${size}x$size)';
    final b = Binder(id: id, name: binderName, cols: size, rows: size, pages: pages);
    setState(() => binders.add(b));
    await saveBinders();
    // navigate to binder view
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => BinderView(binder: b, onChanged: onBinderChanged)))
        .then((_) => saveBinders()); // Cukup simpan perubahan, tidak perlu load ulang dari awal.
  }

  void onBinderChanged(Binder updated) async {
    // 1. Temukan indeks binder yang sedang diedit.
    final index = binders.indexWhere((b) => b.id == updated.id);
    if (index != -1) {
      // 2. Perbarui binder di dalam daftar dengan data yang baru.
      setState(() {
        binders[index] = updated;
      });
    }
  }

  void _changeLanguage(String languageCode) async {
    final locale = Locale(languageCode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    BinderApp.setLocale(context, locale);
  }

  void showCreateSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF262A36), // Pindahkan warna ke sini
      builder: (_) => CreateBinderSheet(onCreate: createBinder),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const primaryTextColor = Color(0xFFE5E5E5);

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2A),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: primaryTextColor,
        title: Text(l10n.homePageTitle),
        actions: [
          PopupMenuButton<String>(
            onSelected: _changeLanguage,
            icon: const Icon(Icons.language, color: primaryTextColor),
            color: const Color(0xFF262A36), // Warna background dropdown
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(value: 'id', child: Text('ID', style: TextStyle(color: primaryTextColor))),
              const PopupMenuItem<String>(value: 'en', child: Text('EN', style: TextStyle(color: primaryTextColor))),
            ],
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : binders.isEmpty
              ? Center(child: Text(l10n.noBinder, style: const TextStyle(color: primaryTextColor)))
              : ListView.builder(
                  itemCount: binders.length,
                  itemBuilder: (c, i) {
                    final b = binders[i];
                    return Dismissible(
                      key: Key(b.id),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        setState(() {
                          binders.removeAt(i);
                        });
                        saveBinders();

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(l10n.binderDeleted(b.name)),
                            action: SnackBarAction(
                              label: l10n.undo,
                              onPressed: () async {
                                setState(() {
                                  binders.insert(i, b);
                                });
                                await saveBinders();
                              },
                            ),
                          ),
                        );
                      },
                      background: Container(
                        color: const Color.fromARGB(255, 161, 66, 66),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3A7F6B),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF4FB492), width: 1),
                        ),
                        child: ListTile(
                          title: Text(b.name, style: const TextStyle(color: primaryTextColor, fontWeight: FontWeight.bold)),
                          subtitle: Text(l10n.binderAfterBuild(b.pages, b.rows, b.cols), style: TextStyle(color: primaryTextColor.withOpacity(0.8))),
                          leading: const Icon(Icons.book, color: primaryTextColor),
                          trailing: const Icon(Icons.chevron_right, color: primaryTextColor),
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) => BinderView(binder: b, onChanged: onBinderChanged)))
                                // 3. Simpan perubahan setelah kembali dari BinderView.
                                .then((_) => saveBinders());
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: showCreateSheet,
        backgroundColor: const Color(0xFF0A6D8C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16), // Default FAB shape
          side: const BorderSide(color: Color(0xFF0E86AD), width: 2),
        ),
        child: const Icon(Icons.add, color: primaryTextColor),
      ),
    );
  }
}