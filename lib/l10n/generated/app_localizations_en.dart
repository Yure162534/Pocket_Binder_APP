// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pocket Binder';

  @override
  String get homePageTitle => 'Pocket Binder';

  @override
  String get newBinder => 'New Binder';

  @override
  String get binderName => 'Binder Name';

  @override
  String get totalPage => 'Total Page';

  @override
  String get pocketStyle => 'Pocket Style';

  @override
  String get noBinder => 'Click + to make new binder';

  @override
  String get exampleRareCollection => 'Example: Rarest Collection\'s';

  @override
  String get changeName => 'Change Name';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get page => 'Page';

  @override
  String get saveAndExit => 'Save & Exit';

  @override
  String get pickACard => 'Pick a Card';

  @override
  String get searchCard => 'Search Card...';

  @override
  String get select => 'Select';

  @override
  String get changeCard => 'Change Card';

  @override
  String get mark => 'Mark';

  @override
  String get emptyPocket => 'Empty Pocket';

  @override
  String get markAsAcquired => 'Mark as \'Acquired\'';

  @override
  String get markAsNotAcquired => 'Mark as \'Not Acquired\'';

  @override
  String get binderNameCannotBeEmpty => 'Binder name cannot be empty!';

  @override
  String get undo => 'Undo';

  @override
  String binderDeleted(Object binderName) {
    return '$binderName has been deleted';
  }

  @override
  String binderAfterBuild(Object pages, Object rows, Object cols) {
    return '$pages Pages, ${rows}x$cols Pocket per Page';
  }
}
