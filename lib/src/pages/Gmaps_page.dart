import 'package:flutter/material.dart';
import 'package:google_maps_rule/src/bloc/bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart'; 
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart'; 

class GmapsPage extends StatefulWidget {
  GmapsPage({Key key}) : super(key: key);

  @override
  _GmapsPageState createState() => _GmapsPageState();
}

class _GmapsPageState extends State<GmapsPage> {
    
  @override
  Widget build(BuildContext context) {
    final provmaps=Provider.of<ProviderMaps>(context);
   return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.blueAccent,
       title:Text("Google Maps - Rule",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
     ),
           body: Stack(
       alignment: Alignment.center,
         children: <Widget>[
       Positioned(
       top: 0,
          child: Container(
         height: MediaQuery.of(context).size.height,
         width: MediaQuery.of(context).size.width,
            child: GoogleMap(
           zoomControlsEnabled: false,
           mapType: MapType.normal,
           compassEnabled: true,           
           markers:provmaps.markers,
           polylines: provmaps.polyline,
           initialCameraPosition: CameraPosition(
           target: provmaps.initialPos, zoom: 18.0),
           onMapCreated:provmaps.onCreated,
           onTap: provmaps.addMarker,
         ),
         
       ),
     ),
     /*,*/
                 
     Positioned(
       bottom: 10,
       right: 0,
       child:Container(
         height: 80,
         width: MediaQuery.of(context).size.width/2,
         decoration: BoxDecoration(
           color: Colors.blueAccent,
           borderRadius: BorderRadius.only(topLeft: Radius.circular(60),bottomLeft:Radius.circular(60)  )
         ),
         child: Row(
           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
           children: <Widget>[
              FloatingActionButton(
               elevation: 1,
               backgroundColor: Colors.white,
               onPressed: (){
               },//provmaps.routermap,
             child:Icon(MdiIcons.ruler,color: Colors.blue,)
             ),
              
             FloatingActionButton(
               elevation: 1,
               backgroundColor: Colors.white,
               onPressed: (){
                 provmaps.markers.clear();
                 provmaps.polylines.clear();
                 provmaps.polyline.clear();
                 setState(() {});
               },
             child: Icon(MdiIcons.trashCanOutline,color: Colors.red,),
             )
           ],
         )          
       )
       ),     
         ],   
     ),
   );   
  } 

}

 