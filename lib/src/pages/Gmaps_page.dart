
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_rule/src/bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:google_maps_rule/src/widget/customdialog.dart';

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
                    polygons:  provmaps.polygon,
                    initialCameraPosition:
                    CameraPosition(target: provmaps.initialPos, zoom: 18.0),
                    onMapCreated: provmaps.onCreated,
                    onTap: provmaps.addMarker,
                  );
                })),
          ),
          Consumer<ProviderMaps>(builder: (context, menu, widget) {
            return AnimatedPositioned(
              bottom: menu.menu == false ? 16 : 150,
              right: 16,
              duration: Duration(milliseconds: 300),
              child: FloatingActionButton(
                heroTag: 'fmnu',
                elevation: 1,
                onPressed: menu.changestatupolyli,
                backgroundColor: menu.selectpolyli == false
                    ? Colors.white
                    : Colors.blueAccent,
                child: Icon(MdiIcons.ruler,
                    color: menu.selectpolyli == false
                        ? Colors.black
                        : Colors.white),
              ),
            );
          }),
          Consumer<ProviderMaps>(builder: (context, menu, widget) {
            return AnimatedPositioned(
              bottom: menu.menu == false ? 16 : 80,
              right: 16,
              duration: Duration(milliseconds: 200),
              child: FloatingActionButton(
                heroTag: 'fme',
                elevation: 1,
                onPressed: menu.changestatutpolyg,
                backgroundColor: menu.selectpolyg == false
                    ? Colors.white
                    : Colors.blueAccent,
                child: Icon(MdiIcons.vectorPolygon,
                    color: menu.selectpolyg == false
                        ? Colors.black
                        : Colors.white),
              ),
            );
          }),
           Positioned(
            bottom: 80,
            right: 90,
             child: Consumer<ProviderMaps>(builder: (context, pickercolor, widget) {
              return pickercolor.selectpolyg==false?Container():FloatingActionButton(
                heroTag: 'fpc',
                onPressed: 
              pickercolor.changeColor,backgroundColor: pickercolor.color,
              shape: CircleBorder(
                side: BorderSide(
                  width: 5,
                  color: Colors.white
                )
              )
              
              //color.changeColor
              );
              
            }),
          ),
           Positioned(
            bottom: 80,
             child: Consumer<ProviderMaps>(builder: (context, color, widget) {
              return color.selectpolyg==false?Container():FloatingActionButton(
                heroTag: 'fc',
                onPressed: 
              color.calcarea,
              child: Icon(MdiIcons.check,color: Colors.blueAccent),
              backgroundColor: Colors.white,
              //color.changeColor
              );
              
            }),
          ),
          Positioned(
              bottom: 16,
              right: 16,
              child: Consumer<ProviderMaps>(builder: (context, menu, widget) {
                return FloatingActionButton(
                  heroTag: 'fm',
                  onPressed: menu.changemenu,
                  backgroundColor: Colors.blueAccent,
                  child:
                  Icon(menu.menu == false ? MdiIcons.menu : MdiIcons.close),
                );
              })),
          Consumer<ProviderMaps>(builder: (context, dialg, widget) {
            return dialg.customdialog == false ? Container() : CustomDialog();
          }),  
        ],
      ),
    );
  }

   
}
