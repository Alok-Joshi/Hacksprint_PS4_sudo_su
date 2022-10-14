import 'package:bookmyspot/components/bottomsheets.dart';
import 'package:bookmyspot/components/buttons.dart';
import 'package:bookmyspot/components/pickers.dart';
import 'package:bookmyspot/components/typography.dart';
import 'package:bookmyspot/constrains.dart';
import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool disablePlage = false;

  Future loadProfile() async {
    setState(() {
      disablePlage = true;
    });
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      disablePlage = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [

        Scaffold(
          appBar: AppBar(
            title: ButtonText(text: "BookMySpot", color: Color(button_primary_color),),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.black),
            actions: [
              IconButton(onPressed: () {
                loadProfile();
              }, icon: Icon(Icons.refresh))
            ],
          ),
          drawer: Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30)
              )
            ),
          ),
          body: Container(
            // height: 600,
            width: MediaQuery.of(context).size.width,
            // color: Colors.pink,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 50,),
                ParkingLayoutBuilder(),
                SizedBox(height: 40,),
                GestureDetector(
                  onTap: () {
                    showBasicBottomModalSheet(context, ReserveSpotOptions());
                  },
                  child: BMSOutlinedButton(
                    child: ButtonText(
                      text: "Reserve Spot",
                      color: Color(button_primary_color),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        disablePlage? Opacity(
          opacity: 0.8,
          child: ModalBarrier(dismissible: false, color: Colors.black),
        ): Container(),
        disablePlage? Center(
          child: CircularProgressIndicator(),
        ): Container(),
      ],
    );
  }
}


class ParkingLayoutBuilder extends StatefulWidget {
  const ParkingLayoutBuilder({Key? key}) : super(key: key);

  @override
  State<ParkingLayoutBuilder> createState() => _ParkingLayoutBuilderState();
}

class _ParkingLayoutBuilderState extends State<ParkingLayoutBuilder> {
  final _timeInstanceController = TextEditingController();

  List<List<int>> parking = [
    [-1, -1, -1, -1, -1, -1, -1, -1, -1],
    [1, 1, 1, 1, 1, 1, 1, 0, 0],
    [0, 0, 0, 0, 0],
    [-1, -1, -1, -1, -1],
    [1, 1, 1, 0, 1, 3, 3, 1, 0],
    [0, 0, 0, 1, 0],
    [-1, -1, -1, -1, -1],
    [1, 1, 1, 0, 0],
    [0, 0, 0, 1, 1],
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 550,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              BMSDateTimePicker(
                width: 230,
                dateController: _timeInstanceController,
              ),
              SizedBox(width: 10,),
              BMSFilledButton(
                width: 100,
                height: 60,
                child: Icon(Icons.arrow_forward_ios, color: Colors.white,),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ParkingLayoutRepresentation(parkingGrid: parking,),
          ),
          Legend()
        ],
      ),
    );
  }
}

class ParkingLayoutRepresentation extends StatelessWidget {
  ParkingLayoutRepresentation({Key? key, required this.parkingGrid}) : super(key: key);
  List<List<int>> parkingGrid;

  Widget gridBuilder() {
    List<Widget> parkingRows = [];

    for (int i = 0; i < parkingGrid.length; i++) {
      List<Widget> temp = [];
      if (parkingGrid[i][0] != -1) {
        temp.add(Text("${i+1}"));
      } else {
        temp.add(Text(""));
      }
      for (int j = 0; j < parkingGrid[i].length; j++) {
        if (parkingGrid[i][j] != -1) {
          temp.add(ParkingSpot(status: parkingGrid[i][j]));
        } else {
          temp.add(PathBlock());
        }
      }

      parkingRows.add(Column(children: temp,));
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: parkingRows,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      height: 400,
      child: Center(child: gridBuilder())
    );
  }
}

class ParkingSpot extends StatelessWidget {
  ParkingSpot({Key? key, required this.status, this.index}) : super(key: key);
  int status;
  int? index;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        decoration: BoxDecoration(
          color: (status == 1) ? Color(0xffFFB7D2) : (status == 0) ? Color(0xff56BBF1) : Colors.white,
          borderRadius: BorderRadius.circular(5)
        ),
        height: 30,
        width: 60,
        
      ),
    );
  }
}

class PathBlock extends StatelessWidget {
  const PathBlock({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xffC7C7C7),
            // borderRadius: BorderRadius.circular(5)
        ),
        height: 38,
        width: 30,

      ),
    );;
  }
}


class Legend extends StatelessWidget {
  const Legend({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 343,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Typography0(text: "15"),
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      color: Color(0xffFFB7D2),
                      borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text("Reserved")
                ],
              ),
            ],
          ),
          Column(
            children: [
              Typography0(text: "40"),
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: Color(0xff56BBF1),
                        borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text("Open")
                ],
              ),
            ],
          ),
          Column(
            children: [
              Typography0(text: "--"),
              Row(
                children: [
                  Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                        color: Color(0xffC7C7C7),
                        borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                  SizedBox(width: 5,),
                  Text("Path")
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ReserveSpotOptions extends StatelessWidget {
  const ReserveSpotOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Typography0(text: "Reserve Parking Spot!"),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/reserve/immediate");
            },
            child: BMSFilledButton(
              child: ButtonText(text: "Immediate",),
            ),
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/reserve/later");
            },
            child: BMSFilledButton(
              child: ButtonText(text: "Later",),
            ),
          ),
          SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: BMSOutlinedButton(
              child: ButtonText(text: "Close", color: Color(button_primary_color),),
            ),
          )
        ],
      ),
    );
  }
}
