// data_provider.dart
import 'package:flutter/material.dart';
import 'package:sewingcalculator/Entity/AccessoryEntity.dart';
import 'package:sewingcalculator/Entity/FeeEntity.dart';
import 'package:sewingcalculator/Entity/Material.dart';
import 'package:sewingcalculator/Helper/FeeHelper.dart';


class DataProvider with ChangeNotifier {
  MaterialList materialList = MaterialList();
  AccessoryList accessoryList = AccessoryList();
  FeeList feeList = FeeList();

  bool ust = true;

  MaterialList get materials => materialList;
  AccessoryList get accessories => accessoryList;
  FeeList get fees => feeList;

  void addMaterial(MaterialEntity material) {
    materialList.add(material);
    notifyListeners();
  }

  void setUSt(bool ust) {
    ust = ust;
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



  double getCalculatedVk([bool with_fees = false]) {
    double vk = getCalculatedEk();

    if (ust) {
      vk = vk * 1.19;
    }

    if (with_fees) {
      vk += feeList.getSum(getCalculatedVk());
    }

    return vk;
  }

  double getCalculatedEk() {
    double ek = 0;

    ek += materialList.getSum();
    ek += accessoryList.getSum();

    for (var f in FeeHelper.fees) {
      ek += f.getFee(ek, true);
    }



    return ek;
  }


}
