// ignore_for_file: file_names

import 'package:sewingcalculator/Helper/FeeHelper.dart';

class FeeEntity {

  String type = "";
  double percentage = 0;
  double fix_fee = 0;
  bool is_active = false;
  bool interactive = false;
  bool on_ek = false;

  double getFee(double ek, {on_ek = true, all = false}) {
    if (!is_active) return 0;
    if ( (this.on_ek != on_ek) && !all) return 0;
    return fix_fee + ( (ek / 100) * percentage);
  }

  FeeEntity({required this.type, required this.percentage, required this.fix_fee, required this.is_active, required this.interactive, required this.on_ek});
}

class FeeList {
  double getSum(double vk) {
    double r = 0;
    for (var f in FeeHelper.fees) {
      r += f.getFee(vk, on_ek: false);
    }
    return r;
  }




}