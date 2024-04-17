import 'package:machine_test_nectar/app/data/models/document_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DocumentDbHelper {
  static const String tableName = 'documents';
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database!;
  }

  /// initializing database
  Future<Database> initDatabase() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'documents_database.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE $tableName(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            filePath TEXT,
            expiryDate INTEGER,
            documentType TEXT
          )
          ''',
        );
      },
      version: 1,
    );
  }

  /// checking whether database has data
  Future<bool> hasData() async {
    final db = await database;
    final count =
        Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM cart')) ??
            0;
    return count > 0;
  }

  /// inserting into database
  Future<CommonMessage> insertDocument(DocumnetModel documnetModel) async {
    final db = await database;
    try {
      final existingDoc = await db.query(
        tableName,
        where: 'filePath = ? AND title = ?',
        whereArgs: [documnetModel.filePath, documnetModel.title],
      );

      if (existingDoc.isEmpty) {
        await db.insert(
          tableName,
          documnetModel.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        return CommonMessage(
          isSuccess: true,
          message: 'Document added successfully',
        );
      } else {
        return CommonMessage(
          isSuccess: false,
          message: 'Item with same title and file already exist',
        );
      }
    } catch (e) {
      return CommonMessage(isSuccess: false, message: '$e');
    }
  }

  /// updating item in database
  Future<CommonMessage> updateDocument(DocumnetModel documnetModel) async {
    final db = await database;
    try {
      await db.update(
        tableName,
        documnetModel.toMap(),
        where: 'id = ?',
        whereArgs: [documnetModel.id],
      );
      return CommonMessage(
        isSuccess: true,
        message: 'Document updated successfully',
      );
    } catch (e) {
      return CommonMessage(isSuccess: false, message: '$e');
    }
  }

  /// getting list from database
  Future<List<DocumnetModel>> getDocuments() async {
    final db = await database;
    final List<Map<String, dynamic>> dataMaps = await db.query(tableName);
    return List.generate(dataMaps.length, (index) {
      return DocumnetModel.fromMap(dataMaps[index]);
    });
  }
}

class CommonMessage {
  final bool isSuccess;
  final String message;

  CommonMessage({required this.isSuccess, required this.message});
}
