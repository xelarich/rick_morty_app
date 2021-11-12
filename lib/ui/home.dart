import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  @override
  void initState() {
    futureCharacter = getCharacter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: FutureBuilder<Character>(
          future: futureCharacter,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: [SizedBox(child: _buildCard(snapshot.data!))],
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }));
}

Widget _buildCard(Character character) {
  return Card(
    margin: EdgeInsets.all(16),
    elevation: 20,
    child: Column(
      children: [
        Align(
            alignment: Alignment.topLeft,
            child: Padding(
                padding: EdgeInsets.all(8),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Image.network(character.image),
                    )))),
        Padding(padding: const EdgeInsets.only(top: 5), child: StarRating()),
        const Divider(
            color: Colors.black54, indent: 24, endIndent: 24, thickness: 2)
      ],
    ),
  );
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
        Expanded(child: Container(
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
