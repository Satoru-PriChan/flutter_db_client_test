import 'package:sqlite_test_flutter_app/MorePracticalDBClient/DBClient.dart';
import 'package:sqlite_test_flutter_app/MorePracticalDBClient/DBObjectProtocol.dart';

class Cat implements DBObjectProtocol {
  final int _id;
  final DBObjectsStrategy strategy = DBObjectsStrategy.cat;
  final String name;
  final int age;

  Cat(this.name, this.age, this._id);

  factory Cat.fromMap(Map<String, dynamic> json) => Cat(
    json['name'],
    json['age'],
    json['id']
  );

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
    };
  }

  @override
  int get id => _id;

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Cat{id: $id, name: $name, age: $age}';
  }
}