import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

class User extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get username => text()();
}

class Purchase extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get quantity => text()();
  TextColumn get user => text().references(User, #username)();
}

LazyDatabase _openConnection() {
  return LazyDatabase(
    () async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'join-example.sqlite'));
      return NativeDatabase.createInBackground(file);
    },
  );
}

@DriftDatabase(
  tables: [User, Purchase],
  queries: {'getUsernames': 'SELECT username FROM user'},
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Get ALL users from db
  Future<List<UserData>> getUsersList() async {
    return await select(user).get();
  }

  // Get ALL usernames from db
  Future<List<String>> getUsersnamesList() async {
    return await getUsernames().get();
  }

  // Insert new user in db
  Future<int> insertUser(UserCompanion userCompanion) async {
    return await into(user).insert(userCompanion);
  }

  // Delete a single user from db
  Future<int> deleteUser(UserData userData) async {
    return await delete(user).delete(userData);
  }

  // Update a user to the db
  Future<bool> updateUser(UserData userData) async {
    return await update(user).replace(userData);
  }

  // Get ALL purchases from db
  Future<List<PurchaseData>> getPurchasesList() async {
    return await select(purchase).get();
  }

  // Insert new user in db
  Future<int> insertPurchases(PurchaseCompanion purchaseCompanion) async {
    return await into(purchase).insert(purchaseCompanion);
  }

  // Delete a single user from db
  Future<int> deletePurchases(PurchaseData purchaseData) async {
    return await delete(purchase).delete(purchaseData);
  }

  // Update a user to the db
  Future<bool> updatePurchase(PurchaseData purchaseData) async {
    return await update(purchase).replace(purchaseData);
  }
}
