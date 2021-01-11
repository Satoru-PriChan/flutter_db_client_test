import 'package:sqlite_test_flutter_app/MorePracticalDBClient/DBClient.dart';

// データベースで取り扱いたいオブジェクトが備えておかなければならない要素をプロトコルとして定義
abstract class DBObjectProtocol {

  int get id;
  DBObjectsStrategy get strategy;

  // Abstract method.
  Map<String, dynamic> toMap();
}