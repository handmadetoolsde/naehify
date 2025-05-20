// ignore_for_file: file_names

import '../Helper/Units.dart';

class AccessoryEntity {
  String type = "";
  late Unit unit;
  double purchase_price_per_unit = 0;
  double amount = 0;

  double getSum() {
    return (purchase_price_per_unit * amount);
  }

  void setUnit(Unit v) {
    unit = v;
  }

  void setType(String s) {
    type = s;
  }
}

class AccessoryList {
  List<AccessoryEntity> accessories = [];

  void add(AccessoryEntity a) {
    accessories.add(a);
  }

  void remove(int i)  {
    accessories.removeAt(i);
  }

  double getSum() {
    double r = 0;
    for (var m in accessories) {
      r += (m.amount * m.purchase_price_per_unit);
    }
    return r;
  }
}