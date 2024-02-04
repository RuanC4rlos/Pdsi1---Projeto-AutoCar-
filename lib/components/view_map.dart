import 'package:auto_car/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ViewMapPage extends StatefulWidget {
  final PlaceLocation initialLocation;
  final bool isReadonly;

  const ViewMapPage({
    Key? key,
    this.initialLocation = const PlaceLocation(
      latitude: 37.419857,
      longitude: -122.078827,
    ),
    this.isReadonly = false,
  }) : super(key: key);

  @override
  State<ViewMapPage> createState() => _ViewMapPageState();
}

class _ViewMapPageState extends State<ViewMapPage> {
  late LatLng _pickedPosition;

  @override
  void initState() {
    super.initState();
    _pickedPosition = LatLng(
      widget.initialLocation.latitude,
      widget.initialLocation.longitude,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Localização do veiculo...'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _pickedPosition,
          zoom: 13,
        ),
        onTap: null,
        markers: {
          Marker(
            markerId: const MarkerId('p1'),
            position: _pickedPosition,
          ),
        },
      ),
    );
  }
}
