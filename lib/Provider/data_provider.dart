// data_provider.dart
import 'package:flutter/material.dart';
import 'package:sewingcalculator/Entity/AccessoryEntity.dart';
import 'package:sewingcalculator/Entity/FeeEntity.dart';
import 'package:sewingcalculator/Entity/Material.dart';
import 'package:sewingcalculator/Helper/FeeHelper.dart';
import 'package:sewingcalculator/Helper/ResultHelper.dart';

import '../Helper/Units.dart';

class DataProvider with ChangeNotifier {
  MaterialList materialList = MaterialList();
  AccessoryList accessoryList = AccessoryList();
  FeeList feeList = FeeList();
  ResultHelper helper = ResultHelper();

  bool ust = true;

  MaterialList get materials => materialList;

  AccessoryList get accessories => accessoryList;

  FeeList get fees => feeList;

  ResultHelper getPositions() {
    helper.removeByType("material");
    for (MaterialEntity e in materialList.materials) {
      helper.add(ResultRow(
          type: "material",
          amount: e.getSum(),
          description:
              '${UnitHelper.formatCurrency(e.amount, false)}${e.unit.unit} ${e.type}'));
    }

    helper.removeByType("accessory");
    for (AccessoryEntity e in accessoryList.accessories) {
      helper.add(ResultRow(
          type: "accessory",
          amount: e.getSum(),
          description:
              '${UnitHelper.formatCurrency(e.amount, false)}${e.unit.unit} ${e.type}'));
    }

    helper.removeByType("fee");
    for (FeeEntity e in FeeHelper.fees) {
      if (e.is_active) {
        helper.add(ResultRow(
            type: "fee",
            amount: e.getFee(getCalculatedVk(with_fees: false), all: true),
            description: '${e.type}'));
      }
    }

    return helper;
  }

  List<FeeEntity> getActiveFees() {
    List<FeeEntity> fees = [];
    for (FeeEntity e in FeeHelper.fees) {
      if (e.is_active) {
        fees.add(e);
      }
    }
    return fees;
  }

  void addMaterial(MaterialEntity material) {
    materialList.add(material);
    notifyListeners();
  }

  void addAccessory(AccessoryEntity accessory) {
    accessoryList.add(accessory);
    notifyListeners();
  }

  void setFee(FeeEntity fee) {
    for (var e in FeeHelper.fees) {
      if (e.type == fee.type) {
        e.is_active = fee.is_active;
        notifyListeners();
      }
    }
  }

  void removeMaterial(int index) {
    materialList.remove(index);
    notifyListeners();
  }

  void removeAccessory(int index) {
    accessoryList.remove(index);
    notifyListeners();
  }

  double getCalculatedVk({bool with_fees = false, bool ust = true}) {
    double vk = getCalculatedEk();

    if (with_fees) {
      vk += feeList.getSum(getCalculatedEk());
    }

    debugPrint("VK: (fees: ${with_fees.toString()})" + vk.toString());

    if (ust && this.ust) {
      vk = vk * 1.19;
    }

    return vk;
  }

  void setUst(bool v) {
    this.ust = v;
    notifyListeners();
  }

  double getUst() {
    if (!this.ust) return 0;
    return (getCalculatedVk(with_fees: true, ust: false) / 100) * 19;
  }

  double getCalculatedEk() {
    double ek = 0;

    ek += materialList.getSum();
    ek += accessoryList.getSum();

    for (var f in FeeHelper.fees) {
      ek += f.getFee(ek, on_ek: true);
    }

    debugPrint("EK: " + ek.toString());

    return ek;
  }
}
