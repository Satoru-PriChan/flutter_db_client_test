import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqlite_test_flutter_app/MorePracticalDBClient/DBClient.dart';

import 'MorePracticalDBClient/Cat.dart';

void main() async {
  // Avoid errors caused by flutter upgrade.
  // Importing 'package:flutter/widgets.dart' is required.
  WidgetsFlutterBinding.ensureInitialized();

  var fido = Cat(
    'fido',
    10,
    1,
  );

  // Insert a dog into the database.
  await DBClient.add(fido);

  // Print the list of dogs (only Fido for now).
  print(await DBClient.query(DBObjectsStrategy.cat));

  // Update Fido's age and save it to the database.
  fido = Cat(
    fido.name,
    fido.age + 7,
    fido.id,
  );
  await DBClient.update(fido);

  // Print Fido's updated information.
  print(await DBClient.query(DBObjectsStrategy.cat));

  // Delete Fido from the database.
  await DBClient.delete(fido.id, DBObjectsStrategy.cat);

  // Print the list of dogs (empty).
  print(await DBClient.query(DBObjectsStrategy.cat));
}
