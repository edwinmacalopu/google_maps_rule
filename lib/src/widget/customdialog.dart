import 'package:flutter/material.dart';
import 'package:google_maps_rule/src/bloc/bloc.dart';
import 'package:provider/provider.dart';

class CustomDialog extends StatefulWidget {
  CustomDialog({Key key}) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
  @override
  Widget build(BuildContext context) {
    final dialg = Provider.of<ProviderMaps>(context);
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
        color: Colors.black.withOpacity(0.5),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[   
          Container(
        height: MediaQuery.of(context).size.height /1.4,
        width: MediaQuery.of(context).size.width / 1.2,
        padding: EdgeInsets.symmetric(vertical: 30,horizontal: 30),
         decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[   
              dialg.imageby==null?Center(child: CircularProgressIndicator()): Container(
               padding: EdgeInsets.all(30),
               height: 230,
               //width: 150,
               decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black26,width: 0.5),
                 image: DecorationImage(image:MemoryImage(dialg.imageby),fit: BoxFit.cover)
               ),
                ),   
           SizedBox(
             height: 20,
           ),     
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Area :', style: TextStyle(fontSize: 16)),
              SizedBox(
             height: 10,
           )  , 
          Text(dialg.area,style: TextStyle(color: Colors.black54)),
            SizedBox(
             height: 20,
           )  , 
                     Text('Dirección aproximada :', style: TextStyle(fontSize: 16)),
                     SizedBox(
             height: 10,
           )  , 
          Text(dialg.direction,style: TextStyle(color: Colors.black54)),
            ],
          ),
          SizedBox(
             height: 20,
           )  , 
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: RaisedButton(
                  elevation: 0,
          color: Colors.blueAccent,
          onPressed: () {
            dialg.changectdialog(false);
          },
          child: Text('Cerrar')),
              ),
               
            ],
        ),
      ),
      
           
     
        ],
    ));
    
  }
}
