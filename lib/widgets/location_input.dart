import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../pages/map_page.dart';

class LocationInput extends StatefulWidget {
  Function _selectPlace;

  LocationInput(this._selectPlace);
  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;
  bool _isLoadingLocation = false;

  void _showPreviewImage(double lat, double lng) {
    final staticMapURL = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    setState(() {
      _previewImageUrl = staticMapURL;
    });
  }

  Future<void> _getCurrentUserLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });
    try {
      final locationData = await Location().getLocation();
      _showPreviewImage(locationData.latitude, locationData.longitude);
      widget._selectPlace(locationData.latitude, locationData.longitude);
    } catch (errror) {
      print('Error getting the location');
      return;
    }
    setState(() {
      _isLoadingLocation = false;
    });
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapPage(
          isSelecting: true,
        ),
      ),
    );
    if (selectedLocation == null) {
      return;
    }
    _showPreviewImage(selectedLocation.latitude, selectedLocation.longitude);

    widget._selectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: _previewImageUrl == null
              ? (!_isLoadingLocation
                  ? Text(
                      'Not location choosen',
                      textAlign: TextAlign.center,
                    )
                  : CircularProgressIndicator())
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text('Current location'),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
              onPressed: _selectOnMap,
              icon: Icon(Icons.map),
              label: Text('Select on Map'),
              textColor: Theme.of(context).primaryColor,
            ),
          ],
        )
      ],
    );
  }
}
