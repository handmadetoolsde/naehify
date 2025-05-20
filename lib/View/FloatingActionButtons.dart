import 'package:flutter/material.dart';


import 'AddAccessoryDialog.dart';
import 'AddMaterialDialog.dart';

class MenuItem {
  final int id;
  final String label;
  final IconData icon;

  MenuItem(this.id, this.label, this.icon);
}

List<MenuItem> menuItems = [
  MenuItem(1, 'Home', Icons.home),
  MenuItem(2, 'Profile', Icons.person),
  MenuItem(3, 'Settings', Icons.settings),
  MenuItem(4, 'Favorites', Icons.favorite),
  MenuItem(5, 'Notifications', Icons.notifications)
];

class FloatingActionButtons {
  late BuildContext context;

  FloatingActionButtons(BuildContext ctx) {
    context = ctx;
  }

  Widget getFab(int view) {

    if (view == 0) {
      return FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => StatefulBuilder(
                    builder: (context, setState) {
                      return AddMaterialDialog();
                    },
                  ));
        },
        child: Icon(Icons.add),
      );
    }

    if (view == 1) {
      return FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) => StatefulBuilder(
                builder: (context, setState) {
                  return AddAccessoryDialog();
                },
              ));
        },
        child: Icon(Icons.add),
      );
    }

    return Visibility(
      visible: false, // Set it to false
      child: FloatingActionButton(
        onPressed: () {},
      ),
    );
  }
}


