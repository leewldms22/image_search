import 'package:image_search/model/image_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbService {
  static final DbService instance = DbService._init();
  static Database? _database;

  DbService._init();
  // get 데이터베이스 인스턴스
  Future<Database> get database async {
    if(_database != null) return _database!;
    _database = await _initDB('favorite.db');
    return _database!;
  }
  // 데이터베이스 초기화
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _createDB(db, newVersion);
    }
  }

  // 테이블 생성
  Future<void> _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const boolType = 'INTEGER NOT NULL';

    await db.execute('''
      CREATE TABLE favorites (
        imageUrl $idType,
        thumbnailUrl $textType,
        displaySitename $textType,
        isFavorite $boolType
      )
    ''');
  }

  Future<int> createFavorite(ImageModel image) async {
    final db = await instance.database;
    return await db.insert('favorites', image.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<ImageModel>> readAllFavorites() async {
    final db = await instance.database;
    const orderBy = 'displaySitename ASC';
    final result = await db.query('favorites', orderBy: orderBy);

    return result.map((json) {
      return ImageModel(
        imageUrl: json['imageUrl'] as String,
        thumbnailUrl: json['thumbnailUrl'] as String,
        displaySiteName: json['displaySitename'] as String,
        isFavorite: true,
      );
    }).toList();
  }

  Future<int> deleteFavorite(String imageUrl) async {
    final db = await instance.database;
    return await db.delete(
      'favorites',
      where: 'imageUrl = ?',
      whereArgs: [imageUrl],
    );
  }

  Future<bool> isFavorite(String imageUrl) async {
    final db = await instance.database;
    final count = Sqflite.firstIntValue(await db.query(
      'favorites',
      where: 'imageUrl = ?',
      whereArgs: [imageUrl],
      limit: 1,
    ));
    return count != null && count > 0;
  }

  Future close() async {
    final db = await instance.database;
    _database = null;
    return db.close();
  }
}