import 'package:bookmyspot/components/bottomsheets.dart';
import 'package:bookmyspot/components/buttons.dart';
import 'package:bookmyspot/components/pickers.dart';
import 'package:bookmyspot/components/typography.dart';
import 'package:bookmyspot/constrains.dart';
import 'package:bookmyspot/pages/my_reservations.dart';
import 'package:bookmyspot/pages/profile_page.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'my_vechicles.dart';

class Dashboard extends StatefulWidget {
  Dashboard({Key? key, this.user}) : super(key: key);
  User? user;

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late User? user;
  bool disablePlage = false;


  Future loadProfile() async {
    setState(() {
      disablePlage = true;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      disablePlage = false;
    });
  }


  @override
  void initState() {
    user  = widget.user ;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   user = user ?? (ModalRoute.of(context)!.settings.arguments as User);

    return Stack(
      children: [

        Scaffold(
          appBar: AppBar(
            title: ButtonText(text: "BookMySpot", color: const Color(button_primary_color),),
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.black),
            actions: [
              IconButton(onPressed: () {
                loadProfile();
              }, icon: const Icon(Icons.refresh))
            ],
          ),
          drawer: Container(
            width: 300,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(30),
                bottomRight: const Radius.circular(30)
              ),
            ),
            child: BMSDrawer(appUser: user!,),
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
                const SizedBox(height: 50,),
                const ParkingLayoutBuilder(),
                const SizedBox(height: 40,),
                GestureDetector(
                  onTap: () {
                    showBasicBottomModalSheet(context, ReserveSpotOptions(user: user!,));
                  },
                  child: BMSOutlinedButton(
                    child: ButtonText(
                      text: "Reserve Spot",
                      color: const Color(button_primary_color),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        disablePlage? const Opacity(
          opacity: 0.8,
          child: const ModalBarrier(dismissible: false, color: Colors.black),
        ): Container(),
        disablePlage? const Center(
          child: const CircularProgressIndicator(),
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
              const SizedBox(width: 10,),
              BMSFilledButton(
                width: 100,
                height: 60,
                child: const Icon(Icons.arrow_forward_ios, color: Colors.white,),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ParkingLayoutRepresentation(parkingGrid: parking,),
          ),
          const Legend()
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
        temp.add(const Text(""));
      }
      for (int j = 0; j < parkingGrid[i].length; j++) {
        if (parkingGrid[i][j] != -1) {
          temp.add(ParkingSpot(status: parkingGrid[i][j]));
        } else {
          temp.add(const PathBlock());
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
          color: (status == 1) ? const Color(0xffFFB7D2) : (status == 0) ? const Color(0xff56BBF1) : Colors.white,
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
        decoration: const BoxDecoration(
          color: Color(0xffC7C7C7),
            // borderRadius: BorderRadius.circular(5)
        ),
        height: 38,
        width: 30,

      ),
    );
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
                      color: const Color(0xffFFB7D2),
                      borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                  const SizedBox(width: 5,),
                  const Text("Reserved")
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
                        color: const Color(0xff56BBF1),
                        borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                  const SizedBox(width: 5,),
                  const Text("Open")
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
                        color: const Color(0xffC7C7C7),
                        borderRadius: BorderRadius.circular(5)
                    ),
                  ),
                  const SizedBox(width: 5,),
                  const Text("Path")
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
  ReserveSpotOptions({Key? key, required this.user}) : super(key: key);
  User user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Typography0(text: "Reserve Parking Spot!"),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/reserve/immediate", arguments: user);
            },
            child: BMSFilledButton(
              child: ButtonText(text: "Immediate",),
            ),
          ),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/reserve/later", arguments: user);
            },
            child: BMSFilledButton(
              child: ButtonText(text: "Later",),
            ),
          ),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: BMSOutlinedButton(
              child: ButtonText(text: "Close", color: const Color(button_primary_color),),
            ),
          )
        ],
      ),
    );
  }
}


class BMSDrawer extends StatelessWidget {
  BMSDrawer({Key? key, required this.appUser}) : super(key: key);
  User appUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 60, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: const Color(button_primary_color),
              borderRadius: BorderRadius.circular(25)
            ),
            child: const Icon(Icons.account_circle, size: 50, color: Colors.white,),
          ),
          const SizedBox(height: 10,),
          Text(appUser.email, style: TextStyle(
            fontSize: 20
          ),),
          const SizedBox(height: 10,),
          const Divider(thickness: 2,),
          const SizedBox(height: 20,),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(appUser: appUser,)));
            },
              child: DrawerOptions(name: "Profile", icon: Icons.account_circle,)),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyVechicles(user: appUser,)));
            },
              child: DrawerOptions(name: "Vehicles", icon: Icons.car_rental,)),
          const SizedBox(height: 10,),
          GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MyReservations(user: appUser)));
            },
              child: DrawerOptions(name: "My Reservations", icon: Icons.schedule,)),
          const SizedBox(height: 10,),
          DrawerOptions(name: "Nearby Parking", icon: Icons.map,),
        ],
      ),
    );
  }
}
