import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In id, this message translates to:
  /// **'Binder Kartu'**
  String get appTitle;

  /// No description provided for @homePageTitle.
  ///
  /// In id, this message translates to:
  /// **'Binder Kartu'**
  String get homePageTitle;

  /// No description provided for @newBinder.
  ///
  /// In id, this message translates to:
  /// **'Buat Binder Baru'**
  String get newBinder;

  /// No description provided for @binderName.
  ///
  /// In id, this message translates to:
  /// **'Nama Binder'**
  String get binderName;

  /// No description provided for @totalPage.
  ///
  /// In id, this message translates to:
  /// **'Jumlah Halaman'**
  String get totalPage;

  /// No description provided for @pocketStyle.
  ///
  /// In id, this message translates to:
  /// **'Pilih Ukuran Grid per Halaman'**
  String get pocketStyle;

  /// No description provided for @noBinder.
  ///
  /// In id, this message translates to:
  /// **'Belum ada binder. Tekan + untuk membuat baru.'**
  String get noBinder;

  /// No description provided for @exampleRareCollection.
  ///
  /// In id, this message translates to:
  /// **'Contoh: Koleksi Kartu Langka'**
  String get exampleRareCollection;

  /// No description provided for @changeName.
  ///
  /// In id, this message translates to:
  /// **'Ganti Nama Binder'**
  String get changeName;

  /// No description provided for @cancel.
  ///
  /// In id, this message translates to:
  /// **'Batal'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In id, this message translates to:
  /// **'Simpan'**
  String get save;

  /// No description provided for @page.
  ///
  /// In id, this message translates to:
  /// **'Halaman'**
  String get page;

  /// No description provided for @saveAndExit.
  ///
  /// In id, this message translates to:
  /// **'Simpan & Kembali'**
  String get saveAndExit;

  /// No description provided for @pickACard.
  ///
  /// In id, this message translates to:
  /// **'Pilih kartu'**
  String get pickACard;

  /// No description provided for @searchCard.
  ///
  /// In id, this message translates to:
  /// **'Cari kartu...'**
  String get searchCard;

  /// No description provided for @select.
  ///
  /// In id, this message translates to:
  /// **'Pilih'**
  String get select;

  /// No description provided for @changeCard.
  ///
  /// In id, this message translates to:
  /// **'Ganti Kartu'**
  String get changeCard;

  /// No description provided for @mark.
  ///
  /// In id, this message translates to:
  /// **'Tandai'**
  String get mark;

  /// No description provided for @emptyPocket.
  ///
  /// In id, this message translates to:
  /// **'Kosongkan Pocket'**
  String get emptyPocket;

  /// No description provided for @markAsAcquired.
  ///
  /// In id, this message translates to:
  /// **'Tandai \'Acquired\''**
  String get markAsAcquired;

  /// No description provided for @markAsNotAcquired.
  ///
  /// In id, this message translates to:
  /// **'Tandai \'Not Acquired\''**
  String get markAsNotAcquired;

  /// No description provided for @binderNameCannotBeEmpty.
  ///
  /// In id, this message translates to:
  /// **'Nama binder tidak boleh kosong!'**
  String get binderNameCannotBeEmpty;

  /// No description provided for @undo.
  ///
  /// In id, this message translates to:
  /// **'Urungkan'**
  String get undo;

  /// No description provided for @binderDeleted.
  ///
  /// In id, this message translates to:
  /// **'{binderName} telah dihapus'**
  String binderDeleted(Object binderName);

  /// No description provided for @binderAfterBuild.
  ///
  /// In id, this message translates to:
  /// **'{pages} halaman, {rows}x{cols} Pocket per halaman'**
  String binderAfterBuild(Object pages, Object rows, Object cols);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
