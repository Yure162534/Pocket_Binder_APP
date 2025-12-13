// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Binder Kartu';

  @override
  String get homePageTitle => 'Binder Kartu';

  @override
  String get newBinder => 'Buat Binder Baru';

  @override
  String get binderName => 'Nama Binder';

  @override
  String get totalPage => 'Jumlah Halaman';

  @override
  String get pocketStyle => 'Pilih Ukuran Grid per Halaman';

  @override
  String get noBinder => 'Belum ada binder. Tekan + untuk membuat baru.';

  @override
  String get exampleRareCollection => 'Contoh: Koleksi Kartu Langka';

  @override
  String get changeName => 'Ganti Nama Binder';

  @override
  String get cancel => 'Batal';

  @override
  String get save => 'Simpan';

  @override
  String get page => 'Halaman';

  @override
  String get saveAndExit => 'Simpan & Kembali';

  @override
  String get pickACard => 'Pilih kartu';

  @override
  String get searchCard => 'Cari kartu...';

  @override
  String get select => 'Pilih';

  @override
  String get changeCard => 'Ganti Kartu';

  @override
  String get mark => 'Tandai';

  @override
  String get emptyPocket => 'Kosongkan Pocket';

  @override
  String get markAsAcquired => 'Tandai \'Acquired\'';

  @override
  String get markAsNotAcquired => 'Tandai \'Not Acquired\'';

  @override
  String get binderNameCannotBeEmpty => 'Nama binder tidak boleh kosong!';

  @override
  String get undo => 'Urungkan';

  @override
  String binderDeleted(Object binderName) {
    return '$binderName telah dihapus';
  }

  @override
  String binderAfterBuild(Object pages, Object rows, Object cols) {
    return '$pages halaman, ${rows}x$cols Pocket per halaman';
  }
}
