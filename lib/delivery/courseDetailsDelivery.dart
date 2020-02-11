import 'package:flutter/material.dart';
import 'package:bringme/services/crud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'QrCodeToScan.dart';
import 'package:expandable/expandable.dart';

class CourseDetailsDelivery extends StatefulWidget {
  CourseDetailsDelivery(
      {@required this.type,
      @required this.time,
      @required this.coursedata,
      @required this.courseID});

  final String type;
  final Timestamp time;
  final DocumentSnapshot coursedata;
  final String courseID;

  @override
  State<StatefulWidget> createState() {
    return _CourseDetailsDeliveryState();
  }
}

class _CourseDetailsDeliveryState extends State<CourseDetailsDelivery> {
  CrudMethods crudObj = new CrudMethods();

  Map<String, dynamic> _userId = {};

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      _isLoading = true;
    });
    crudObj
        .getDataFromUserFromDocumentWithID(widget.coursedata['userId'])
        .then((value) {
      setState(() {
        _userId = value.data;
      });
      setState(() {
        _isLoading = false;
      });
    });
  }

  _launchURL(phone) async {
    String url = 'tel:' + phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _launchMap(adresse) async {
    var url = "google.navigation:q=$adresse";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Non disponible $url';
    }
  }


  Widget profilInfoUser() {
    return Container(
      padding: EdgeInsets.only(top: 16),
      child: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Color.fromRGBO(0, 0, 0, 1),
                width: 6,
              ),
            ),
            child: CircleAvatar(
              // photo de profil
              backgroundImage: NetworkImage(_userId['picture']),
              minRadius: 30,
              maxRadius: 93,
            ),
          ),
          Container(
            height: 15,
          ),
        ],
      ),
    );
  }


  Widget _deliveryManInfo() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Information sur l'utilisateur",
            style: TextStyle(fontSize: font * 20),
          ),
          profilInfoUser(),
          Padding(
            padding: const EdgeInsets.fromLTRB(25.0,0.0,25.0,5.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(_userId['name'], style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w600),),
                ],
              ),
            ),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Card(
                  child: ListTile(
                    title: Text("Nom"),
                    subtitle: Text(_userId['surname']),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Email"),
                    subtitle: Text(_userId['mail']),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: Text("Numéro"),
                    subtitle: Text(_userId['phone']),
                    trailing: FlatButton(
                      child: Icon(Icons.phone),
                      onPressed: () {
                        _launchURL(_userId['phone']);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deliveryInfo() {
    String _typeRemorque = '';

    widget.coursedata['typeOfRemorque'].forEach((k, v) {
      if (v == true) {
        _typeRemorque += k.toString() + ' ';
      }
    });

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    double font = MediaQuery.of(context).textScaleFactor;

    return Container(
      child: Column(
        children: <Widget>[
          Text(
            "Information sur la livraison",
            style: TextStyle(fontSize: font * 20),
          ),
          widget.coursedata['object'] != null ? Card(
            child: ListTile(
              title: Text("Object de la course"),
              subtitle: Text(widget.coursedata['object']),
            ),
          ) : Container(),
          Card(
            child: ListTile(
              title: Text("Depart"),
              subtitle: Text(widget.coursedata['depart']),
              trailing: Icon(FontAwesomeIcons.mapMarkerAlt),
              onTap: () {
                _launchMap(widget.coursedata['depart']);
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Heure de retrait"),
              subtitle: Text(DateFormat('HH:mm')
                  .format(widget.coursedata['retraitDate'].toDate())),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Destination"),
              subtitle: Text(widget.coursedata['destination']),
              trailing: Icon(FontAwesomeIcons.mapMarkerAlt),
              onTap: () {
                _launchMap(widget.coursedata['destination']);
              },
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Heure de livraison"),
              subtitle: Text(DateFormat('HH:mm')
                  .format(widget.coursedata['deliveryDate'].toDate())),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Type de marchandise"),
              subtitle: Text(widget.type),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Type de remorque"),
              subtitle: Text(_typeRemorque),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Prix de la course"),
              subtitle: Text(widget.coursedata['price'] + "€"),
            ),
          ),
          Card(
            child: ListTile(
              title: Text("Description de la course"),
              subtitle: widget.coursedata['description'] == null ||
                  widget.coursedata['description'] == ''
                  ? Text("Pas de description")
                  : ExpandablePanel(
                header: Text(""),
                collapsed: Text(
                  widget.coursedata['description'],
                  softWrap: true,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                expanded:
                Text(widget.coursedata['description'], softWrap: true),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pageConstruct() {
    return ListView(children: <Widget>[
      Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            _deliveryManInfo(),
            Container(
              height: 30.0,
            ),
            _deliveryInfo()
          ],
        ),
      ),
    ]);
  }

  Widget _showCircularProgress() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("A livrer pour " +
            DateFormat('HH:mm').format(widget.time.toDate())),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.qrcode),
            onPressed: () {
              print(widget.courseID);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QrCodeToScan(
                          courseID: widget.courseID,
                          courseData: widget.coursedata)));
            },
          ),
        ],
      ),
      body: _isLoading ? _showCircularProgress() : _pageConstruct(),
    );
  }
}
