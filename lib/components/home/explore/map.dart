import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:location/location.dart';

// Starting point latitude
double _originLatitude = 0.3442615;
// Starting point longitude
double _originLongitude = 32.6544786;
// Destination latitude
double _destLatitude = 0.265956;
// Destination Longitude
double _destLongitude = 32.552264;
// Markers to show points on the map
Map<MarkerId, Marker> markers = {};

PolylinePoints polylinePoints = PolylinePoints();
Map<PolylineId, Polyline> polylines = {};

class MapScreen extends StatefulWidget {
  final double fromLatitude;
  final double fromLongitude;
  final double destLatitude;
  final double destLongitude;

  MapScreen({required this.fromLatitude, required this.fromLongitude, required this.destLatitude, required this.destLongitude});
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  // Google Maps controller
  Completer<GoogleMapController> _controller = Completer();
  // Configure map position and zoom
  // static final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(_originLatitude, _originLongitude),
  //   zoom: 11.5,
  // );
  
  String API_KEY = "your_api_key";

  @override
  void initState() {
    /// add origin marker origin marker
    _addMarker(
      LatLng(widget.fromLatitude, widget.fromLongitude),
      "origin",
      BitmapDescriptor.defaultMarker,
    );

    // Add destination marker
    _addMarker(
      LatLng(widget.destLatitude, widget.destLongitude),
      "destination",
      BitmapDescriptor.defaultMarkerWithHue(90),
    );

    _getPolyline();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Text('On Map'),
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.fromLatitude, widget.fromLongitude),
            zoom: 11.5,
          ),
          myLocationEnabled: true,
          tiltGesturesEnabled: true,
          compassEnabled: true,
          scrollGesturesEnabled: true,
          zoomGesturesEnabled: true,
          polylines: Set<Polyline>.of(polylines.values),
          markers: Set<Marker>.of(markers.values),
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
    );
  }

  // This method will add markers to the map based on the LatLng position
  _addMarker(LatLng position, String id, BitmapDescriptor descriptor) {
    MarkerId markerId = MarkerId(id);
    Marker marker =
    Marker(markerId: markerId, icon: descriptor, position: position);
    markers[markerId] = marker;
  }

  _addPolyLine(List<LatLng> polylineCoordinates) {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      points: polylineCoordinates,
      width: 8,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  void _getPolyline() async {
    List<LatLng> polylineCoordinates = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "API_KEY",
      PointLatLng(widget.fromLatitude, widget.fromLongitude),
      PointLatLng(widget.destLatitude, widget.destLongitude),
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    _addPolyLine(polylineCoordinates);
  }
}
