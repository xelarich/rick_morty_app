import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:rick_morty_app/data/model/all_characters.dart';
import 'package:rick_morty_app/data/model/character.dart';
import 'package:rick_morty_app/data/repository/repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Character> futureCharacter;
  var indexPage = 1;
  Random random = Random();

  @override
  void initState() {
    futureCharacter = getCharacter(random.nextInt(825) + 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<Character>(
          future: futureCharacter,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              Character data = snapshot.data!;
              return Slidable(
                  startActionPane: ActionPane(
                    motion: BehindMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red.shade700,
                        onPressed: (context) => setState(() {
                          futureCharacter =
                              getCharacter(random.nextInt(825) + 1);
                        }),
                        foregroundColor: Colors.white,
                        icon: Icons.thumb_down,
                        label: 'Dislike',
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: BehindMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green.shade700,
                        onPressed: (context) => setState(() {
                          futureCharacter =
                              getCharacter(random.nextInt(825) + 1);
                        }),
                        foregroundColor: Colors.white,
                        icon: Icons.thumb_up,
                        label: 'Like',
                      ),
                    ],
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.45,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.network(data.image,
                                width: MediaQuery.of(context).size.width,
                                fit: BoxFit.cover),
                          ),
                          Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 16),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Title(
                                    color: Colors.white,
                                    child: Text(
                                      data.name,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28),
                                    )),
                              )),
                          Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 16),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Title(
                                    color: Colors.white,
                                    child: Text(
                                      data.species,
                                      textAlign: TextAlign.start,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 20),
                                    )),
                              )),
                          Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 0, 8),
                                      child: Icon(Icons.thumb_up_outlined,
                                          color: Colors.grey.shade400,size: 28)),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
                                      child: Text(
                                        '0',
                                        style: TextStyle(
                                            color: Colors.grey.shade400,fontSize: 28),
                                      )),
                                ],
                              ),
                            ],
                          ),
                          /*ButtonBar(
                            alignment: MainAxisAlignment.end,
                            children: [
                              FloatingActionButton.extended(
                                label: Text("Dislike"),
                                icon: const Icon(Icons.thumb_down),
                                backgroundColor: Colors.red.shade700,
                                onPressed: () {
                                  // Perform some action
                                },
                              ),
                              FloatingActionButton.extended(
                                label: Text("Like"),
                                icon: const Icon(Icons.thumb_up),
                                backgroundColor: Colors.lightGreen.shade700,
                                onPressed: () {
                                  // Perform some action
                                },
                              )
                            ],
                          ),*/
                        ],
                      ),
                    ),
                  ));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }));
}

ListView _jobsListView(List<Character> data) {
  return ListView.builder(
      itemCount: data.length,
      itemBuilder: (context, index) {
        return _buildItemList(context, data[index]);
      });
}

Widget _buildItemList(BuildContext context, Character character) {
  return Card(
    margin: const EdgeInsets.all(16),
    elevation: 20,
    color: Colors.white,
    shadowColor: Colors.green.shade200,
    child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 150,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(0),
                  ),
                  child: Image.network(character.image,
                      width: 150, height: 150, fit: BoxFit.cover),
                ),
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(8, 8, 0, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          character.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Row(
                          children: [
                            Padding(
                                padding: EdgeInsets.all(4),
                                child: Icon(Icons.circle,
                                    color: getStatusColor(character.status),
                                    size: 16)),
                            Text(
                              "${character.status} - ${character.species}",
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8, 4, 0, 0),
                          child: Text(
                            "Origin",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(character.origin.name,
                              style: const TextStyle(fontSize: 12)),
                        ),
                        const Padding(
                          padding: EdgeInsets.fromLTRB(8, 4, 0, 0),
                          child: Text(
                            "Actual Location",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                          child: Text(character.location.name,
                              style: const TextStyle(fontSize: 12)),
                        )
                      ],
                    ))
              ],
            )
          ],
        )),
  );
}

Color getStatusColor(String status) {
  switch (status) {
    case "Alive":
      {
        return Colors.green;
      }
    case "Dead":
      {
        return Colors.red;
      }
    case "unknown":
      {
        return Colors.grey;
      }
    default:
      {
        return Colors.white;
      }
  }
}
