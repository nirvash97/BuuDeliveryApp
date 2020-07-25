import 'package:buudeli/util/style1.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class AddShopInfo extends StatefulWidget {
  @override
  _AddShopInfoState createState() => _AddShopInfoState();
}

class _AddShopInfoState extends State<AddShopInfo> {
//Field
  double lat, lng;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    findLatLng();
  }

  Future<Null> findLatLng() async {
    LocationData locationData = await findLocation();
    setState(() {
      lat = locationData.latitude;
      lng = locationData.longitude;
    });
    print('lat = $lat , lng =$lng');
  }

  Future<LocationData> findLocation() async {
    Location location = Location();
    try {
      return location.getLocation();
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Shop Information')),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            nameForm(),
            addressForm(),
            phoneForm(),
            groupImage(),
            Style1().mysizebox(),
            lat == null ? Style1().showProgress() : showMap(),
            Style1().mysizebox(),
            saveButton()
          ],
        ),
      ),
    );
  }

  Widget saveButton() {
    return Container(
      width: 300.0,
      child: RaisedButton.icon(
        color: Colors.amber,
        onPressed: () {},
        icon: Icon(Icons.save),
        label: Text('บันทึกข้อมูล'),
      ),
    );
  }

  Container showMap() {
    LatLng latLng = LatLng(lat, lng);
    CameraPosition cameraPosition = CameraPosition(
      target: latLng,
      zoom: 16.0,
    );
    return Container(
      height: 300.0,
      child: GoogleMap(
        initialCameraPosition: cameraPosition,
        mapType: MapType.normal,
        onMapCreated: (controller) {},
        markers: gmMarker(),
      ),
    );
  }

  Set<Marker> gmMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('myShop'),
        position: LatLng(lat, lng),
        infoWindow: InfoWindow(
          title: 'ร้านของคุณ',
          snippet: 'latitude : $lat , longitude: $lng',
        ),
      )
    ].toSet();
  }

  Row groupImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10.0),
          child: IconButton(
              icon: Icon(
                Icons.add_a_photo,
                size: 30.0,
              ),
              onPressed: () {}),
        ),
        Container(
          width: 200.0,
          child: Image.asset('images/t1.png'),
        ),
        Container(
          margin: EdgeInsets.only(right: 10.0),
          child: IconButton(
            icon: Icon(
              Icons.add_photo_alternate,
              size: 36.0,
            ),
            onPressed: () {},
          ),
        )
      ],
    );
  }

  Widget nameForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            width: 250.0,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ชื่อของร้านค้า',
                prefixIcon: Icon(Icons.home),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );

  Widget addressForm() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0),
            width: 250.0,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'ที่อยู่ของร้านค้า',
                prefixIcon: Icon(Icons.account_box),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ],
      );
}

Widget phoneForm() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
          width: 250.0,
          child: TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'เบอร์โทรของร้านค้า',
              prefixIcon: Icon(Icons.account_box),
              border: OutlineInputBorder(),
            ),
          ),
        ),
      ],
    );
