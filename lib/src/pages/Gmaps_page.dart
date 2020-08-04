import 'package:flutter/material.dart';
import 'package:google_maps_rule/src/bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GmapsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Consumer<ProviderMaps>(
                      builder: (context, provmaps, widget) {
                    return GoogleMap(
                      myLocationEnabled: false,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      compassEnabled: true,
                      mapType: MapType.normal,
                      markers: provmaps.markers,
                      polylines: provmaps.polyline,
                      initialCameraPosition: CameraPosition(
                          target: provmaps.initialPos, zoom: 18.0),
                      onMapCreated: provmaps.onCreated,
                      onTap: provmaps.addMarker,
                    );
                  })),
            ),
          ],
        ),
        floatingActionButton:
            Consumer<ProviderMaps>(builder: (context, deletemap, widget) {
          return deletemap.markers.length==0?Container():FloatingActionButton(
            onPressed: () {
              deletemap.deletemap();
            },
            child: Icon(MdiIcons.trashCan),
          );
        }));
  }
}
