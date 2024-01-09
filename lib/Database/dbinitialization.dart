import 'package:path_provider/path_provider.dart'; //to connect to application document directory
import 'package:sqflite/sqflite.dart'; //database creation
import 'package:path/path.dart'; // to set path to database present in application document directory
import 'dart:async';
import 'dart:io';
import 'package:estore/Cart/cartItems.dart';

class Dbfiles {
  Dbfiles();

  static late Database
      _db; // static declares that the variable belongs to the class itself, not the instance of class

  Future<Database> get db async {
    _db = await initializeDb(); //db initialization
    return _db;
  }

  Future<Database> initializeDb() async {
    Directory documentDirectory =
        await getApplicationDocumentsDirectory(); //access to application directory
    // ignore: unused_local_variable
    String path = await getDatabasesPath(); //set path to directory
    String dbPath = join(await documentDirectory.path,
        "cart.db"); //create database title and link paths
    var cartDb = await openDatabase(dbPath, version: 1, onCreate: createTable);
    return cartDb;
  }

  FutureOr<void> createTable(Database db, int version) async {
    await db.execute('''CREATE TABLE cart_items(
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT, 
      category TEXT,
      size TEXT,
      price INTEGER,
      imagePath TEXT,
      qtysold INTEGER, 
      product_no INTEGER)
  ''');
  }

  Future<List<CartItem>> getCartItems() async {
    final Database db = await this.db;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');
    return List.generate(maps.length, (i) {
      return CartItem(
        id: maps[i]['id'],
        title: maps[i]['title'] ?? '',
        category: maps[i]['category'] ?? '',
        size: maps[i]['size'] ?? '',
        price: maps[i]['price'] ?? 0,
        imagePath: maps[i]['imagePath'] ?? '',
        qtySold: maps[i]['qtysold'] ?? 0,
        productNo: maps[i]['product_no'] ?? 0,
      );
    });
  }

  // Function to insert a cart item into the database
  Future<void> insertCartItem(CartItem cartItem) async {
    final Database db = await this.db;
    if (cartItem.id == 0) {
      // Exclude 'id' from the map when it's 0 to let the database generate a new id
      await db.insert(
        'cart_items',
        cartItem.toMap()..remove('id'),
      );
    } else {
      await db.insert(
        'cart_items',
        cartItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Function to delete a cart item from the database
  Future<void> deleteCartItem(int productNo) async {
  final Database db = await this.db;
  await db.delete(
    'cart_items',
    where: 'product_no = ?',
    whereArgs: [productNo],
  );
}
}
