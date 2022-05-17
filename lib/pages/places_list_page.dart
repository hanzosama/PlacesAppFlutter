import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/places_detail_page.dart';
import '../pages/add_place_page.dart';
import '../providers/places_provider.dart';

class PlacesListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlacePage.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: PlaceListWidget(),
    );
  }
}

class PlaceListWidget extends StatefulWidget {
  @override
  State<PlaceListWidget> createState() => _PlaceListWidgetState();
}

class _PlaceListWidgetState extends State<PlaceListWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Provider.of<PlacesProvider>(context, listen: false)
          .fetchAndSetPlaces(),
      builder: (ctx, snapShot) => snapShot.connectionState ==
              ConnectionState.waiting
          ? Center(child: CircularProgressIndicator())
          : Consumer<PlacesProvider>(
              builder: (ctx, places, ch) => places.items.length <= 0
                  ? ch
                  : ListView.builder(
                      itemCount: places.items.length,
                      itemBuilder: (ctx, index) => Dismissible(
                        key: Key(places.items[index].id),
                        background: Container(color: Colors.red),
                        onDismissed: (direction) {
                          setState(() {
                            Provider.of<PlacesProvider>(context, listen: false)
                                .removeById(places.items[index].id);
                            //places.items.removeAt(index);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Place deleted!')));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(places.items[index].image),
                          ),
                          title: Text(places.items[index].title),
                          subtitle: Text(places.items[index].location.address),
                          onTap: () {
                            // go to detail
                            Navigator.of(context).pushNamed(
                                PlaceDetailPage.routeName,
                                arguments: places.items[index].id);
                          },
                        ),
                      ),
                    ),
              child: Center(
                child: const Text('Got no places yet, start adding some!'),
              ),
            ),
    );
  }
}
