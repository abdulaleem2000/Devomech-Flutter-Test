import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Devomech'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var colors1 =['red','blue','black'];
  var colors2 = ['blue','black','red'];
  var colors3 = ['black','red','blue'];
  var index=-1;
  //var colors = ['red','blue','black','blue','black','red','black','red','blue'];
  List<Color> colors = [Colors.red, Colors.blue, Colors.black ,Colors.blue,Colors.black,Colors.red,Colors.black,Colors.red,Colors.blue,
    Colors.red, Colors.blue, Colors.black ,Colors.blue,Colors.black,Colors.red,Colors.black,Colors.red,Colors.blue,
    Colors.red, Colors.blue, Colors.black ,Colors.blue,Colors.black,Colors.red,Colors.black,Colors.red,Colors.blue,
    Colors.red, Colors.blue, Colors.black ];
  Future fetchData() async{
    var response = await http.get(Uri.parse("https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/Tiger_King/daily/20210901/20210930"));
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    List<dynamic> data1 = jsonData["items"] ;


    /*for(var d in jsonData){
      Data data = Data(d['article'],d['granularity'],d['project'],d['timeStamp'],d['view']);
      datas.add(data);

    }*/

    print(data1.length);

    return data1;

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(


        child:Card(
          child: FutureBuilder(
            future: fetchData(),
            builder: (context,snapshot){
              if(snapshot.data==null){
                return Container(
                  child: Center(
                    child: Text("Loading...."),
                  ),
                );
              }else{
                var data = (snapshot.data as List<dynamic>).toList();
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context,i){
                    var ds = data[i]['timestamp'].toString().split("");
                    print(ds);


                    return
                      InkWell(
                        onTap: (){
                          showDialog(context: context, builder: (context)=>AlertDialog(
                            title: Text('Delete'),
                            actions: [
                              TextButton(onPressed: ()=>{
                                if(colors[i-1]==colors[i+1]){
                                  showDialog(context: context, builder: (context)=>AlertDialog(
                          title: Text('Two consecutive same colors are not allowed'),
                          ))
                                }
                                else{

                                  data.removeAt(i),
                                  print(data.length),
                                  setState(() {

                                  })
                                },
                                Navigator.pop(context)
                              }, child: Text("Delete"))
                            ],
                          ));
                        },
                          child:Padding(padding: const EdgeInsets.symmetric(vertical: 8.0),

                            child: Container(
                              padding: EdgeInsets.all(10),

                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(5)),
                                  color: colors[i]
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(data[i]['project'],style: TextStyle(color: Colors.white, fontFamily: 'avenir' ,fontSize: 20,fontWeight: FontWeight.bold),),
                                      Text(data[i]['granularity'],style: TextStyle(color: Colors.white, fontFamily: 'avenir' ),)

                                    ],
                                  ),

                                  Row(

                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [

                                      Text(data[i]['article'],style: TextStyle(color: Colors.white, fontFamily: 'avenir' ),),
                                      Text(ds[6]+ds[7]+'-'+ds[4]+ds[5]+'-'+ds[0]+ds[1]+ds[2]+ds[3],style: TextStyle(color: Colors.white, fontFamily: 'avenir' ),)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [

                                      Text(data[i]['views'].toString(),style: TextStyle(color: Colors.white, fontFamily: 'avenir' ),)
                                    ],
                                  )
                                ],
                              ),

                            ),

                          )
                      );

                  });
              }
            },
          ),
        ),
      ),
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  getColor() {
    index++;
    print(index);
    if(index>=colors.length){
      index=0;
    }
    return colors[index];
  }
}


class Data{
  String project,article,granularity,timeStamp,view;

  Data(this.article,this.granularity,this.project,this.timeStamp,this.view);

}
