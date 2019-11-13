import 'package:flutter/material.dart';
import 'package:bringme/main.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  MyDrawer(this.currentPage);

  final String currentPage;


  Widget _createHeader() {
    return DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        child: Stack(children: <Widget>[
          Positioned(
              bottom: 12.0,
              left: 16.0,
              child: Text("Bienvenu !",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w500))),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    var currentDrawer = Provider.of<DrawerStateInfo>(context).getCurrentDrawer;
    return Drawer(
      child: ListView(
        children: <Widget>[
          _createHeader(),
          ListTile(
            title: Text(
              "Accueil",
              style: currentDrawer == 0
                  ? TextStyle(fontWeight: FontWeight.bold)
                  : TextStyle(fontWeight: FontWeight.normal),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).pop();
              if (this.currentPage == "home") return;

              Provider.of<DrawerStateInfo>(context).setCurrentDrawer(0);

              Navigator.pushReplacementNamed(context, "/");
            },
          ),
          ListTile(
            title: Text(
              "Proposition",
              style: currentDrawer == 1
                  ? TextStyle(fontWeight: FontWeight.bold)
                  : TextStyle(fontWeight: FontWeight.normal),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).pop();
              if (this.currentPage == "proposition") return;

              Provider.of<DrawerStateInfo>(context).setCurrentDrawer(1);

              Navigator.pushReplacementNamed(context, "/userProposition");
            },
          ),
          ListTile(
            title: Text(
              "Courses",
              style: currentDrawer == 2
                  ? TextStyle(fontWeight: FontWeight.bold)
                  : TextStyle(fontWeight: FontWeight.normal),
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).pop();
              if (this.currentPage == "courses") return;

              Provider.of<DrawerStateInfo>(context).setCurrentDrawer(2);

              Navigator.pushReplacementNamed(context, "/userCourses");
            },
          ),
        ],
      ),
    );
  }
}