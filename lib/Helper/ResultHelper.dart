class ResultHelper {
  List<ResultRow> list = [];

  add(ResultRow row) {
    list.add(row);
  }

  removeByType(String type) {
    list.removeWhere((e) => e.type == type);
  }

  List<ResultRow> getByType(String type) {
    List<ResultRow> data = [];
    for(ResultRow e in list) {
      if (e.type == type) data.add(e);
    }
    return data;
  }

  double sumByType(String type) {
    double data = 0;
    for(ResultRow e in list) {
      if (e.type == type) data += e.amount;
    }
    return data;
  }
}

class ResultRow {
  final String description;
  final double amount;
  final String type;

  const ResultRow(
      {required this.type, required this.description, required this.amount});
}
