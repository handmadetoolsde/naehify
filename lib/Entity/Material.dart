// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:sewingcalculator/Helper/Units.dart';


class MaterialEntity {
  String type = "";
  late Unit unit;
  double purchase_price_per_unit = 0;
  double amount = 0;

  void setType(String v) {
    debugPrint("setType: $v");
    type = v;
  }

  void setUnit(Unit v) {
    debugPrint("setUnit: ${v.identifier}");
    unit = v;
  }

  double getSum() {
    return (purchase_price_per_unit * amount);
  }
}

class MaterialList {
  List<MaterialEntity> materials = [];

  void add(MaterialEntity m) {
    materials.add(m);
  }

  void remove(int i)  {
    materials.removeAt(i);
  }

  double getSum() {
    double r = 0;
    for (var m in materials) {
      r += (m.amount * m.purchase_price_per_unit);
    }
    return r;
  }
}


