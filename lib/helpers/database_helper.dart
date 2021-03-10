import 'package:app_anuncio/helpers/anuncio_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class DatabaseHelper {
  Database _db;

  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
      return _db;
    }
  }

  Future<Database> initDB() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'anuncioLista.db');
    try {
      Database db = await openDatabase(
          path, version: 2, onCreate: _onCreate, onUpgrade: _onUpgrade);
      return db;
    } catch (e) {
      print(e);
    }
  }
  Future _onCreate(Database db, int version) async {
      await db.execute(AnuncioHelper.createScript);
    }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      await db.execute("DROP TABLE ${AnuncioHelper.nomeLabel};");
      _onCreate(db, newVersion);
    }
  }
}