import 'package:flutter/material.dart';
import 'package:bringme/user/myDrawer.dart';
import 'package:bringme/authentification/auth.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:bringme/services/crud.dart';
import 'courseDetails.dart';

class UserCourses extends StatefulWidget {
  final BaseAuth auth = new Auth();

  @override
  State<StatefulWidget> createState() {
    return _UserCoursesState();
  }
}

class _UserCoursesState extends State<UserCourses> {
  String userId;
  List<dynamic> _courseList = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: true);

  CrudMethods crudObj = new CrudMethods();

  void initState() {
    super.initState();
    widget.auth.currentUserId().then((id) {
      setState(() {
        userId = id;
      });
    });
  }

  Future<dynamic> _refresh() {
    return crudObj.getUserCourses().then((value) {
      setState(() {
        _courseList = value.documents;
      });
      _refreshController.refreshCompleted();
    });
  }

  Future<dynamic> _onLoading() {
    return crudObj.getUserCourses().then((value) {
      setState(() {
        _courseList = value.documents;
      });
      _refreshController.loadComplete();
    });
  }

  listConstruct(index) {
    return ListTile(
      title: Text(_courseList[index]['typeOfMarchandise']),
      subtitle:
          Text("heure de livraison " + _courseList[index]['deliveryTime']),
      trailing: FlatButton(
        child: Text(
          "détails",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CourseDetails(
                  type: _courseList[index]['typeOfMarchandise'],
                  time: _courseList[index]['deliveryTime'],
                  coursedata: _courseList[index],
                ),
              ));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Courses"),
      ),
      drawer: MyDrawer(
        currentPage: "courses",
        userId: userId,
      ),
      body: SmartRefresher(
          header: BezierCircleHeader(),
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          onLoading: _onLoading,
          onRefresh: _refresh,
          child: ListView.builder(
            itemCount: _courseList.length,
            itemBuilder: (context, index) {
              return listConstruct(index);
            },
          )),
    );
  }
}