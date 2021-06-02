import 'package:flutter/material.dart';
import 'package:flutter_tutorial_3/movie_details.kt.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'movie.dart';

class StudentListPage extends StatefulWidget {
  @override
  _StudentListPageState createState() => _StudentListPageState();
}

class _StudentListPageState extends State<StudentListPage> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context,
              snapshot) //this functio is called every time the "future" updates
          {
        // Check for errors
        if (snapshot.hasError) {
          return FullScreenText(text: "Something went wrong");
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          //BEGIN: the old MyApp builder from last week
          return ChangeNotifierProvider(
              create: (context) => MovieModel(),
              child: Consumer<MovieModel>(builder: buildScaffold));
          //END: the old MyApp builder from last week
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return FullScreenText(text: "Loading");
      },
    );
  }

  Scaffold buildScaffold(BuildContext context, MovieModel movieModel, _) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        leading: BackButton(
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),

      //added this
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return MovieDetails();
              });
        },
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //YOUR UI HERE
            if (movieModel.loading)
              CircularProgressIndicator()
            else
              Expanded(
                child: ListView.builder(
                    itemBuilder: (_, index) {
                      var movie = movieModel.items[index];
                      return Dismissible(
                        child: ListTile(
                          title: Text(movie.title),
                          subtitle: Text(movie.year.toString() +
                              " - " +
                              movie.duration.toString() +
                              " Minutes"),
                          leading: movie.image != null
                              ? Image.network(movie.image)
                              : null,
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return MovieDetails(id: movie.id);
                            }));
                          },
                        ),
                        background: Container(
                          color: Colors.green,
                        ),
                        key: UniqueKey(),
                        onDismissed: (direction) {
                          setState(() {
                            movieModel.delete(movie.id);
                          });
                        },
                      );
                    },
                    itemCount: movieModel.items.length),
              )
          ],
        ),
      ),
    );
  }
}

//A little helper widget to avoid runtime errors -- we can't just display a Text() by itself if not inside a MaterialApp, so this workaround does the job
class FullScreenText extends StatelessWidget {
  final String text;

  const FullScreenText({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Column(children: [Expanded(child: Center(child: Text(text)))]));
  }
}
