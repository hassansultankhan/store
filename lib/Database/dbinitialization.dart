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
    String path = await getDatabasesPath(); //set path to directory
    String dbPath = join(await documentDirectory.path,
        "cart.db"); //create database title and link paths
    var cartDb = await openDatabase(dbPath, version: 1, onCreate: createTable);
    return cartDb;
  }

  FutureOr<void> createTable(Database db, int version) async {
    await db.execute('''Create table cart_items(
            id INTEGER PRIMARY KEY,
            title TEXT, 
            category TEXT,
            size TEXT,
            price INTEGER,
            quantity INTEGER,
            product_no INTEGER)
            ''');
  }

  Future<List<CartItem>> getCartItems() async {
    final Database db = await this.db;
    final List<Map<String, dynamic>> maps = await db.query('cart_items');
    return List.generate(maps.length, (i) {
      return CartItem(
        id: maps[i]['id'],
        title: maps[i]['title'] ?? '', // Use an empty string if title is null
        category: maps[i]['category'] ?? '',
        size: maps[i]['size'] ?? '',
        price: maps[i]['price'] ?? 0, // Use 0 if price is null
        qtySold: maps[i]['quantity'] ?? 0,
        productNo: maps[i]['product_no'] ?? 0,
      );
    });
  }

  // Function to insert a cart item into the database
  Future<void> insertCartItem(CartItem cartItem) async {
    final Database db = await this.db;
    await db.insert(
      'cart_items',
      cartItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm
          .replace, //This option specifies that if there's a conflict (i.e., a row with the same primary key already exists), replace the existing row with the new data.
    );
  }

  // Function to delete a cart item from the database
  Future<void> deleteCartItem(int id) async {
    final Database db = await this.db;
    await db.delete(
      'cart_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}