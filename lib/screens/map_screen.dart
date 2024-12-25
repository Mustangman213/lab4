import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  final List<LatLng> eventLocations;

  MapScreen({required this.eventLocations});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Event Locations')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: eventLocations.isNotEmpty
              ? eventLocations[0]
              : LatLng(41.9981, 21.4254),
          zoom: 12,
        ),
        markers: eventLocations
            .map((location) => Marker(
                  markerId: MarkerId(location.toString()),
                  position: location,
                ))
            .toSet(),
      ),
    );
  }
}
