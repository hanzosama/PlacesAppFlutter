import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/add_place_page.dart';
import 'pages/places_list_page.dart';
import 'pages/places_detail_page.dart';
import 'providers/places_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PlacesProvider(),
      child: MaterialApp(
        title: 'Great Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amber,
        ),
        home: PlacesListPage(),
        routes: {
          AddPlacePage.routeName: (ctx) => AddPlacePage(),
          PlaceDetailPage.routeName: (ctx) => PlaceDetailPage(),
        },
      ),
    );
  }
}
