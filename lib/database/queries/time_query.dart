class TimeQuery {
  static const String TABLE_NAME = "times";
  static const String CREATE_TABLE =
      " CREATE TABLE IF NOT EXISTS $TABLE_NAME ( id INTEGER PRIMARY KEY AUTOINCREMENT, time INTEGER  ) ";
  static const String SELECT = "select * from $TABLE_NAME";
}