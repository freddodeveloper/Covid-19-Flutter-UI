import 'package:covid_19/API/consume.dart';
import 'package:covid_19/constant.dart';
import 'package:covid_19/model/data_covid.dart';
import 'package:covid_19/widgets/counter.dart';
import 'package:covid_19/widgets/my_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Covid 19',
      theme: ThemeData(
          scaffoldBackgroundColor: kBackgroundColor,
          fontFamily: "Poppins",
          textTheme: TextTheme(
            body1: TextStyle(color: kBodyTextColor),
          )),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //final controller = ScrollController();
  Consume consume = Consume();
  double offset = 0;
  int infectados = 0;
  int muertes = 0;
  int recuperados = 0;
  var paisActual = "Ecuador";
  var image = "";
  List<DropdownMenuItem> paises;
  List<DataCovid> dataCovid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //controller.addListener(onScroll);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //controller.dispose();
    super.dispose();
  }

  /*void onScroll() {
    setState(() {
      offset = (controller.hasClients) ? controller.offset : 0;
    });
  }*/

  Future _cargarData() async {
    paises = [];
    dataCovid = [];
    List<DropdownMenuItem> paisesAux = [];
    List<DataCovid> aux= await consume.loadCountries();
    for(int i=0;i<aux.length;i++) {
      var dataCovid = aux[i];
      paisesAux.add(DropdownMenuItem(
        child: Text(dataCovid.country),
        value: dataCovid.country,
      ));
    }
    paises = paisesAux;
    dataCovid = aux;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          MyHeader(
            image: "assets/icons/Drcorona.svg",
            textTop: "Quedate",
            textBottom: "en Casa.",
            offset: offset,
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            height: 60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Color(0xFFE5E5E5),
              ),
            ),
            child: Row(
              children: <Widget>[
                SvgPicture.asset("assets/icons/maps-and-flags.svg"),
                SizedBox(width: 20),
                Expanded(
                  child: FutureBuilder(
                    future: _cargarData(),
                    builder: (context, snapshot){
                      switch(snapshot.connectionState){
                        case ConnectionState.none:
                          // TODO: Handle this case.
                          break;
                        case ConnectionState.waiting:
                          // TODO: Handle this case.
                          break;
                        case ConnectionState.active:
                          // TODO: Handle this case.
                          break;
                        case ConnectionState.done:
                          // TODO: Handle this case.
                          return DropdownButton(
                            items: paises,
                            onChanged: (value) {
                              setState(() {
                                paisActual = value;
                                var aux = dataCovid.singleWhere((data) => data.country == paisActual);
                                infectados = aux.cases;
                                muertes = aux.deaths;
                                recuperados = aux.recovered;
                                image = aux.flag;
                              });
                            },
                            value: paisActual,
                            isExpanded: false,
                            underline: SizedBox(),
                            hint: Text("Select"),
                            icon: SvgPicture.asset("assets/icons/dropdown.svg"),
                          );
                          break;
                      }
                      return Container();
                    },
                  )
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 4),
                        blurRadius: 30,
                        color: kShadowColor,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Counter(
                        color: kInfectedColor,
                        number: infectados,
                        title: "Infectados",
                      ),
                      Counter(
                        color: kDeathColor,
                        number: muertes,
                        title: "Muertes",
                      ),
                      Counter(
                        color: kRecovercolor,
                        number: recuperados,
                        title: "Recuperados",
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(20),
                  height: 178,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 10),
                        blurRadius: 30,
                        color: kShadowColor,
                      ),
                    ],
                  ),
                  child: image.isNotEmpty ? Image.network(
                    image,
                  ) : Container()
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
