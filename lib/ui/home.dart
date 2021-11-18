import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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
  var like = 0;
  var dislike = 0;
  Random random = Random();

  @override
  void initState() {
    futureCharacter = getCharacter(random.nextInt(825) + 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      body:
          Column(children: [
            FutureBuilder<Character>(
                future: futureCharacter,
                builder: (context, character) {
                  if (character.hasData) {
                    Character data = character.data!;
                    return homeCardCharacter(data);
                  } else if (character.hasError) {
                    return Text('${character.error}');
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }),
            //FutureBuilder<Location>(builder: builder)
          ],)
      );

  Widget homeCardCharacter(Character data) {
    return Slidable(
        startActionPane: ActionPane(
          motion: BehindMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.transparent,
              onPressed: (context) => setState(() {
                like = 0;
                dislike = 0;
                futureCharacter = getCharacter(random.nextInt(825) + 1);
              }),
              foregroundColor: Colors.white,
              icon: Icons.refresh,
              label: 'Refresh',
            ),
          ],
        ),
        endActionPane: ActionPane(
          motion: BehindMotion(),
          children: [
            SlidableAction(
              backgroundColor: Colors.green.shade700,
              onPressed: (context) => setState(() {
                like++;
              }),
              foregroundColor: Colors.white,
              icon: Icons.thumb_up,
              label: 'Like',
            ),
            SlidableAction(
              backgroundColor: Colors.red.shade700,
              onPressed: (context) => setState(() {
                dislike++;
              }),
              foregroundColor: Colors.white,
              icon: Icons.thumb_down,
              label: 'Dislike',
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
                    padding: const EdgeInsetsDirectional.only(start: 16),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Title(
                          color: Colors.white,
                          child: Text(
                            data.name,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 28),
                          )),
                    )),
                Padding(
                    padding: const EdgeInsetsDirectional.only(start: 16),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      child: Title(
                          color: Colors.white,
                          child: Text(
                            data.species,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                fontWeight: FontWeight.normal, fontSize: 20),
                          )),
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Icon(Icons.thumb_up_outlined,
                                color: Colors.green.shade700, size: 20)),
                        Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                              '$like',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 20),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                            child: Icon(Icons.thumb_down_outlined,
                                color: Colors.red.shade700, size: 20)),
                        Padding(
                            padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                            child: Text(
                              '$dislike',
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 20),
                            )),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

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
