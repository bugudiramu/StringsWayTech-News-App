import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final List items = List.generate(20, (i) => i);
  @override
  Widget build(BuildContext context) {
    // final name = Firestore.instance
    //     .collection('swleaderboard')
    //     .document()
    //     .get()
    //     .then((DocumentSnapshot ds) {
    //   return ds['name'].toString();
    // });
    // final price = Firestore.instance
    //     .collection('swleaderboard')
    //     .document()
    //     .get()
    //     .then((DocumentSnapshot ds) {
    //   return ds['price'].toString();
    // });
    return Scaffold(
      appBar: AppBar(
        title: Text('LeaderBoard'.toUpperCase()),
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.only(
            top: 30.0, left: 20.0, right: 20.0, bottom: 5.0),
        color: Color(0Xffc7ecee),
        child: Card(
          elevation: 7.0,
          color: Color(0Xffc7ecee),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  // Expanded(child: leaderCard(120.0, Color(0Xffc7ecee))),
                  // customCard(),
                  SizedBox(width: 1.0),
                  Expanded(child: leaderCard(Colors.white70)),
                  SizedBox(width: 1.0),
                  // Expanded(child: leaderCard(120.0, Color(0Xffc7ecee))),
                ],
              ),
              SizedBox(
                height: 3.0,
                child: Container(
                  color: Color(0Xaaced6e0),
                ),
              ),
              Expanded(
                child: Container(
                  // height: 600.0,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: Firestore.instance
                          .collection('swleaderboard')
                          .orderBy("rating", descending: true)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasError) {
                          return Text(snapshot.error);
                        }
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                            return Center(child: new Text('Loading...'));
                          default:
                            return new ListView(
                              children: snapshot.data.documents
                                  .map((DocumentSnapshot document) {
                                return new ListTile(
                                  leading: Container(
                                    height: 80.0,
                                    width: 60.0,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: NetworkImage(
                                              document['profile_pic']),
                                        )),
                                  ),
                                  title: new Text(document['name']
                                      .toString()
                                      .toUpperCase()),
                                  subtitle: new Text("\$ ${document['price']}"),
                                  trailing: Container(
                                    width: 50.0,
                                    height: 32.0,
                                    alignment: Alignment.center,
                                    child: Text(
                                      document['rating'],
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Color(0xffe58e26),
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget leaderCard(Color color) {
    int i=0;
    return Container(
      height: 140,
      width: 120,
      color: color,
      alignment: Alignment.center,
      child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('swleaderboard')
              .orderBy("rating", descending: true)
              .limit(3)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            }
            return new GridView.count(
              crossAxisCount: 3,
              mainAxisSpacing:0.5,
              childAspectRatio: 0.72,
              children:
                  snapshot.data.documents.map((DocumentSnapshot document) {
                    i++;
                return new Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Positioned.fill(
                      child: Card(
                        key: ValueKey(document.data),
                        color: getcolor(i),
                                                //elevation: 3,
                                                child: Column(
                                                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: <Widget>[
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text(document['name']),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Text("\$" + document['price']),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Container(
                                                      child: gettext(i),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(6),
                                                          
                                                          color: Colors.red),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: -1,
                                              left: 33,
                                              child: CircleAvatar(
                                                child: Image.network(document['profile_pic']),
                                              ),
                                            ),
                                          ],
                                          overflow: Overflow.visible,
                                        );
                                      }).toList(),
                                      //crollDirection: Axis.vertical,
                                    );
                                  }),
                            );
                          }
                        
                          getcolor(int i) {
                            if(i==1)
                            return Colors.white;
                            else return Colors.white60;
                          }

  gettext(int i) {
    if(i==1)
    return  Text("first.".toUpperCase(),style: TextStyle(
      color: Colors.amberAccent
    ),);
  else if(i==2)
    return  Text("second".toUpperCase(),style: TextStyle(
      color: Colors.cyan));
    else if(i==3)
    return  Text("Third".toUpperCase(),style: TextStyle(
      color: Colors.cyan));
  }

  
}
