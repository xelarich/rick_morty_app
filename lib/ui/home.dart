import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rick_morty_app/data/model/all_characters.dart';
import 'package:rick_morty_app/data/model/character.dart';
import 'package:rick_morty_app/data/repository/repository.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<Character> futureCharacter;
  late Future<AllCharacters> futureAllCharacter;
  var indexPage = 1;

  @override
  void initState() {
    Random random = Random();
    //futureCharacter = getCharacter(random.nextInt(825) + 1);
    futureAllCharacter = getAllCharacters(indexPage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<AllCharacters>(
          future: futureAllCharacter,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Character> data = snapshot.data!.results;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(child: _jobsListView(data)),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      onSurface: Colors.white,
                                      primary: Colors.lightGreen[700]),
                                  onPressed: (snapshot.data!.info.prev == null)
                                      ? null
                                      : () {
                                          setState(() {
                                            indexPage--;
                                            futureAllCharacter =
                                                getAllCharacters(indexPage);
                                          });
                                        },
                                  child: const Icon(Icons.arrow_back))),
                          Expanded(
                            child: Text(
                              "Page $indexPage",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      onSurface: Colors.white,
                                      primary: Colors.lightGreen[700]),
                                  onPressed: (snapshot.data!.info.next == null)
                                      ? null
                                      : () {
                                          setState(() {
                                            indexPage++;
                                            futureAllCharacter =
                                                getAllCharacters(indexPage);
                                          });
                                        },
                                  child: const Icon(Icons.arrow_forward))),
                        ],
                      ),
                    )
                  ]);
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

class StarRating extends StatefulWidget {
  StarRating({Key? key}) : super(key: key);

  @override
  StarRatingState createState() => StarRatingState();
}

class StarRatingState extends State<StarRating> {
  var value = 0.0;

  StarRatingState();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Container(
          alignment: Alignment.center,
          child: SmoothStarRating(
            rating: value,
            isReadOnly: false,
            borderColor: Colors.black12,
            color: Colors.black54,
            size: 24,
            onRated: (index) {
              setState(() => value = index);
            },
          ),
        )),
        Expanded(
            child: Container(
                alignment: Alignment.center,
                child: Text('$value/5 ',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.robotoCondensed(
                        color: Colors.black54, fontSize: 20))))
      ],
    );
  }
}
