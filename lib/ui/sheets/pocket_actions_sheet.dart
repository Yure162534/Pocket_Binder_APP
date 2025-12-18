import 'package:binder_app/l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

class PocketActionsSheet extends StatelessWidget {
  final bool isAcquired;
  final AppLocalizations l10n;
  const PocketActionsSheet({super.key, required this.isAcquired, required this.l10n});

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFFE5E5E5);

    return SafeArea(
      child: Wrap(
        children: <Widget>[
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: textColor),
            title: Text(l10n.changeCard, style: const TextStyle(color: textColor)),
            onTap: () => Navigator.pop(context, 'change'),
          ),
          ListTile(
            leading: Icon(isAcquired ? Icons.visibility_off : Icons.visibility, color: textColor),
            title: Text(isAcquired ? l10n.markAsNotAcquired : l10n.markAsAcquired, style: const TextStyle(color: textColor)),
            onTap: () => Navigator.pop(context, 'toggle_acquired'),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Colors.red.shade700),
            title: Text(l10n.emptyPocket, style: TextStyle(color: Colors.red.shade700)),
            onTap: () => Navigator.pop(context, 'empty'),
          ),
          const Divider(height: 1, color: Colors.white24),
          ListTile(
            title: Center(child: Text(l10n.cancel, style: const TextStyle(color: textColor))),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}