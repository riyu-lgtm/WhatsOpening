import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:flu/Screens/Map.dart';
import 'package:flu/Models/POIModel.dart';
import 'package:flu/Screens/Panel.dart';
import 'package:flu/Screens/StaticFOAMinfo.dart';
class Home extends StatefulWidget{

  HomeState createState() => HomeState();
}
class HomeState extends State<Home>{
  POIModel model;
  bool mode = true;
  MapUi map;

  setModel(POIModel model){
    setState(() {
      this.model = model;
    });
  }
  _refresh(){
    this.model = null;

  }
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final GlobalKey<MapState> _MapState = GlobalKey<MapState>();
    final double _initFabHeight = 120.0;
    double _fabHeight = 120.0;
    double _panelHeightOpen;
    double _panelHeightClosed = 95.0;
    return SlidingUpPanel(
      backdropTapClosesPanel: true,
      backdropEnabled: true,
      renderPanelSheet: true,
      backdropOpacity: 0.5,
      panelSnapping: false,
      borderRadius: BorderRadius.only(topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      parallaxEnabled: true,
      parallaxOffset: 1,
      onPanelSlide: (double pos) => setState((){
        _fabHeight = pos * (_panelHeightOpen - _panelHeightClosed) + _initFabHeight;
      }),
      panel: Center(
        child: model==null?FoamInfo():new PanelUi(model,_MapState,_refresh),
      ),
      collapsed: Container(),
      body: CupertinoPageScaffold(

        navigationBar: CupertinoNavigationBar(
          trailing: Icon(Icons.gps_fixed, size: 20,),
          middle: Text(
            "FOAM Maps",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ),

        child: Stack(

            children:[
              MapUi(setModel: setModel,),
              Positioned(
                right: 20.0,
                bottom: _fabHeight,
                child: FloatingActionButton(
                  child: Icon(
                    Icons.gps_fixed,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: (){},
                  backgroundColor: Colors.white,
                ),
              ),

              Positioned(

                top: MediaQuery.of(context).size.height*0.13,
                left: MediaQuery.of(context,).size.width *0.3,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24.0, 6.0, 24.0, 6.0),
                  child: FlatButton(
                    onPressed: ()async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var pvt = prefs.getString("privateKey");
                      if(pvt!=null){
                        Navigator.pushNamed(context, '/dashboard');
                      }
                      else{
                        Navigator.pushNamed(context, '/LoginWithoutSkip');
                      }

                    },
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.account_circle),
                        Text(
                          "Dashboard",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24.0),
                    boxShadow: [BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, .25),
                        blurRadius: 16.0
                    )],
                  ),
                ),
              ),


            ]
        ),
      ),
    );
  }


}