import 'package:path/path.dart';
import 'package:qr_code_scanner/models/qr_code_model.dart';
import 'package:sqflite/sqflite.dart';

class QrCodeDatabase {
  static Database? database;

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'qr_codes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE qr_codes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            link TEXT
          ) 
        ''');
      },
    );
  }

  Future<Database> getDatabase() async {
    if (database != null) {
      return database!;
    }
    database = await initDatabase();
    return database!;
  }

  Future<int> insertQrCodes(QrCodeModel qrCode) async {
    Database db = await getDatabase();
    return await db.insert('qr_codes', qrCode.toJson());
  }

  Future<List<QrCodeModel>> getQrCodes() async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> qrCodes = await db.query(
      'qr_codes',
      orderBy: 'id DESC',
    );
    return List.generate(qrCodes.length, (index) {
      return QrCodeModel.fromJson(qrCodes[index]);
    });
  }

  Future<int> deleteQrCode(int id) async {
    Database db = await getDatabase();
    return await db.delete(
      'qr_codes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updateQrCodeName(int id, String newName) async {
    Database db = await getDatabase();
    return await db.update(
      'qr_codes',
      {'name': newName},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<QrCodeModel>> searchQrCode(String name) async {
    Database db = await getDatabase();
    List<Map<String, dynamic>> maps = await db.query(
      'qr_codes',
      where: 'name LIKE ?',
      whereArgs: [
        '%$name%',
      ],
      orderBy: 'id DESC',
    );
    return List.generate(maps.length, (index) {
      return QrCodeModel.fromJson(maps[index]);
    });
  }
}
