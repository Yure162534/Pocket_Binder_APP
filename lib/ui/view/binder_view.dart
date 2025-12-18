import 'package:binder_app/core/database/db.dart';
import 'package:binder_app/l10n/generated/app_localizations.dart';
import 'package:binder_app/core/models/binder_models.dart';
import 'package:binder_app/ui/sheets/card_picker_sheet.dart';
import 'package:binder_app/ui/dialogs/filter_dialog.dart';
import 'package:binder_app/ui/sheets/pocket_actions_sheet.dart';
import 'package:flutter/material.dart';

class BinderView extends StatefulWidget {
  final Binder binder;
  final Function(Binder) onChanged;

  const BinderView({
    super.key,
    required this.binder,
    required this.onChanged,
  });

  @override
  _BinderViewState createState() => _BinderViewState();
}

class _BinderViewState extends State<BinderView> {
  late Binder b;
  int currentPage = 0;

  Map<String, CardModel> cardDataCache = {};

  bool _isSearching = false;
  final _searchController = TextEditingController();
  Set<String> _activeFilters = {};

  List<Map<String, int>> _searchResults = [];
  int _currentSearchResultIndex = -1;

  @override
  void initState() {
    super.initState();
    b = Binder.fromJson(widget.binder.toJson());
    _loadAllCardData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadAllCardData() async {
    final allCards = await cardService.getAllCards();
    if (mounted) {
      setState(() {
        cardDataCache = {for (var card in allCards) card.id: card};
      });
    }
  }

  Future<void> persist() async {
    widget.onChanged(b);
  }

  void _executeSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchResults.clear();
        _currentSearchResultIndex = -1;
      });
      return;
    }

    final results = <Map<String, int>>[];

    for (int pageIdx = 0; pageIdx < b.slots.length; pageIdx++) {
      for (int pocketIdx = 0;
          pocketIdx < b.slots[pageIdx].length;
          pocketIdx++) {
        final slot = b.slots[pageIdx][pocketIdx];
        if (slot.cardId != null) {
          final card = cardDataCache[slot.cardId];
          if (card != null &&
              card.title.toLowerCase().contains(query.toLowerCase())) {
            results.add({'page': pageIdx, 'pocket': pocketIdx});
          }
        }
      }
    }

    setState(() {
      _searchResults = results;
      _currentSearchResultIndex = results.isNotEmpty ? 0 : -1;
      if (_currentSearchResultIndex != -1) {
        _navigateToSearchResult(_currentSearchResultIndex);
      }
    });
  }

  void _navigateToSearchResult(int index) {
    if (index >= 0 && index < _searchResults.length) {
      final result = _searchResults[index];
      setState(() => currentPage = result['page']!);
    }
  }

  void _showFilterDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final selectedFilters = await showDialog<Set<String>>(
      context: context,
      builder: (context) => FilterDialog(
        initialFilters: _activeFilters,
        l10n: l10n,
      ),
    );

    if (selectedFilters != null) {
      setState(() {
        _activeFilters = selectedFilters;
        if (_isSearching) {
          _searchController.clear();
          _searchResults.clear();
          _currentSearchResultIndex = -1;
        }
      });
    }
  }

  void _showEditNameDialog() {
    final l10n = AppLocalizations.of(context)!;
    final nameController = TextEditingController(text: b.name);
    const textColor = Color(0xFFE5E5E5);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2A),
        title: Text(
          l10n.changeName,
          style: const TextStyle(color: textColor),
        ),
        content: TextField(
          controller: nameController,
          autofocus: true,
          style: const TextStyle(color: textColor),
          decoration: InputDecoration(
            hintText: l10n.binderName,
            hintStyle: TextStyle(color: textColor.withOpacity(0.6)),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: textColor.withOpacity(0.6)),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: textColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(l10n.cancel,
                style: const TextStyle(color: textColor)),
          ),
          TextButton(
            onPressed: () {
              final newName = nameController.text.trim();
              if (newName.isNotEmpty) {
                setState(() {
                  b.name = newName;
                });
                persist();
              }
              Navigator.pop(dialogContext);
            },
            child:
                Text(l10n.save, style: const TextStyle(color: textColor)),
          ),
        ],
      ),
    );
  }

  void openPocket(int pageIndex, int pocketIndex) async {
    final slot = b.slots[pageIndex][pocketIndex];

    if (slot.cardId == null) {
      final selectedId = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => FractionallySizedBox(
          heightFactor: 0.85,
          child: CardPickerSheet(selectedCardId: slot.cardId),
        ),
      );

      if (selectedId != null) {
        setState(() {
          slot.cardId = selectedId;
          slot.isAcquired = true;
        });
        await persist();
      }
    } else {
      final cardModel = cardDataCache[slot.cardId];
      if (cardModel == null) return;

      final result = await showModalBottomSheet<String>(
        context: context,
        backgroundColor: const Color(0xFF1E1E2A),
        builder: (context) => PocketActionsSheet(
          isAcquired: slot.isAcquired,
          l10n: AppLocalizations.of(context)!,
        ),
      );

      if (result == 'toggle_acquired') {
        setState(() => slot.isAcquired = !slot.isAcquired);
        await persist();
      } else if (result == 'empty') {
        setState(() => slot.cardId = null);
        await persist();
      } else if (result == 'change') {
        final newSelectedId = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          builder: (ctx) => FractionallySizedBox(
            heightFactor: 0.85,
            child: CardPickerSheet(selectedCardId: slot.cardId),
          ),
        );

        if (newSelectedId != null) {
          setState(() => slot.cardId = newSelectedId);
          await persist();
        }
      }
    }
  }

  Widget pocketWidget(int pageIndex, int pocketIndex) {
    final slot = b.slots[pageIndex][pocketIndex];
    final cardId = slot.cardId;

    bool isSearchResult = false;
    if (_currentSearchResultIndex != -1) {
      final currentResult = _searchResults[_currentSearchResultIndex];
      isSearchResult = currentResult['page'] == pageIndex &&
          currentResult['pocket'] == pocketIndex;
    }

    if (_activeFilters.isNotEmpty && cardId != null) {
      final cardModel = cardDataCache[cardId];
      if (cardModel != null) {
        final parts = cardModel.subtitle.split(' - ');
        final rarity =
            parts.length > 1 ? parts.last.trim() : cardModel.subtitle.trim();
        if (!_activeFilters.contains(rarity)) {
          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color.fromARGB(255, 40, 107, 128).withOpacity(0.2),
            ),
          );
        }
      }
    }

    if (cardId == null) {
      return GestureDetector(
        onTap: () => openPocket(pageIndex, pocketIndex),
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: const Color.fromARGB(255, 40, 107, 128),
          ),
          child: const Center(
            child:
                Icon(Icons.add, size: 28, color: Color(0xFFE5E5E5)),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: () => openPocket(pageIndex, pocketIndex),
      child: Builder(
        builder: (context) {
          final cardModel = cardDataCache[cardId];
          if (cardModel == null) {
            return const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          final highlightBorder = isSearchResult
              ? Border.all(color: Colors.amber.shade700, width: 3)
              : Border.all(color: Colors.grey.shade400);

          return Container(
            margin: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(8),
              border: highlightBorder,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    cardModel.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.error)),
                    loadingBuilder:
                        (context, child, loadingProgress) =>
                            loadingProgress == null
                                ? child
                                : const Center(
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  ),
                  ),
                  if (!slot.isAcquired)
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final fontSize =
                            constraints.maxWidth * 0.12;
                        final shadowBlur = fontSize * 0.3;
                        return Container(
                          color: Colors.black.withOpacity(0.6),
                          child: Center(
                            child: Text(
                              'Not Acquired',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: fontSize,
                                shadows: [
                                  Shadow(
                                    blurRadius: shadowBlur,
                                    color: Colors.black,
                                    offset: const Offset(1.0, 1.0),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final perPage = b.rows * b.cols;
    final l10n = AppLocalizations.of(context)!;
    const primaryTextColor = Color(0xFFE5E5E5);

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        if (didPop) await persist();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E2A),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: primaryTextColor,
          title: GestureDetector(
            onTap: _showEditNameDialog,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(b.name),
                const SizedBox(width: 8),
                const Icon(Icons.edit,
                    size: 18, color: primaryTextColor),
              ],
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.filter_list,
                  color: _activeFilters.isNotEmpty
                      ? Colors.amber.shade600
                      : primaryTextColor),
              onPressed: _showFilterDialog,
            ),
            IconButton(
              icon: Icon(
                  _isSearching ? Icons.close : Icons.search,
                  color: primaryTextColor),
              onPressed: () {
                setState(() {
                  _isSearching = !_isSearching;
                  if (!_isSearching) {
                    _searchController.clear();
                    _searchResults.clear();
                    _currentSearchResultIndex = -1;
                  } else if (_activeFilters.isNotEmpty) {
                    _activeFilters.clear();
                    _currentSearchResultIndex = -1;
                  }
                });
              },
            ),
          ],
          bottom: !_isSearching
              ? null
              : PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            autofocus: true,
                            style: const TextStyle(
                                color: primaryTextColor),
                            decoration: InputDecoration(
                              hintText:
                                  '${l10n.searchCard}...',
                              hintStyle: TextStyle(
                                  color: primaryTextColor
                                      .withOpacity(0.7)),
                              border: InputBorder.none,
                            ),
                            onChanged: _executeSearch,
                          ),
                        ),
                        Text(
                          _searchResults.isEmpty
                              ? ''
                              : '${_currentSearchResultIndex + 1}/${_searchResults.length}',
                          style: const TextStyle(
                              color: primaryTextColor),
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_upward,
                              color: primaryTextColor),
                          onPressed: (_currentSearchResultIndex > 0)
                              ? () {
                                  setState(() =>
                                      _currentSearchResultIndex--);
                                  _navigateToSearchResult(
                                      _currentSearchResultIndex);
                                }
                              : null,
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_downward,
                              color: primaryTextColor),
                          onPressed:
                              (_currentSearchResultIndex != -1 &&
                                      _currentSearchResultIndex <
                                          _searchResults.length - 1)
                                  ? () {
                                      setState(() =>
                                          _currentSearchResultIndex++);
                                      _navigateToSearchResult(
                                          _currentSearchResultIndex);
                                    }
                                  : null,
                        ),
                      ],
                    ),
                  ),
                ),
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 78),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF233447),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: const Color(0xFF2d425a),
                          width: 1),
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: perPage,
                      gridDelegate:
                          SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: b.cols,
                        mainAxisSpacing: 4,
                        crossAxisSpacing: 4,
                        childAspectRatio: 3 / 4,
                      ),
                      itemBuilder: (c, i) =>
                          pocketWidget(currentPage, i),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A6D8C),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFF0E86AD),
                        width: 1.5),
                  ),
                  child: IconButton(
                    iconSize: 32.0,
                    icon: const Icon(Icons.chevron_left,
                        color: primaryTextColor),
                    onPressed: currentPage > 0
                        ? () =>
                            setState(() => currentPage--)
                        : null,
                  ),
                ),
                const SizedBox(width: 18),
                Text(
                  '${l10n.page} ${currentPage + 1} / ${b.pages}',
                  style: const TextStyle(
                      color: primaryTextColor, fontSize: 24),
                ),
                const SizedBox(width: 18),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A6D8C),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: const Color(0xFF0E86AD),
                        width: 1.5),
                  ),
                  child: IconButton(
                    iconSize: 32.0,
                    icon: const Icon(Icons.chevron_right,
                        color: primaryTextColor),
                    onPressed: currentPage < b.pages - 1
                        ? () =>
                            setState(() => currentPage++)
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
