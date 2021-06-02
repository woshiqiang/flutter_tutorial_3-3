import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Movie
{
  String id;
  String title;
  int year;
  num duration;
  String image;

  Movie({this.title, this.year, this.duration, this.image});
  Movie.fromJson(Map<String, dynamic> json)
      :
        title = json['title'],
        year = json['year'],
        duration = json['duration'];

  Map<String, dynamic> toJson() =>
      {
        'title': title,
        'year': year,
        'duration' : duration
      };
}

class MovieModel extends ChangeNotifier {
  /// Internal, private state of the list.
  final List<Movie> items = [];

  //added this
  CollectionReference moviesCollection = FirebaseFirestore.instance.collection('movies');

  //added this
  bool loading = false;
  Movie get(String id)
  {
    if (id == null) return null;
    return items.firstWhere((movie) => movie.id == id);
  }
  void add(Movie item) async
  {
    loading = true;
    notifyListeners();

    await moviesCollection.add(item.toJson());

    //refresh the db
    await fetch();
  }

  void update(String id, Movie item) async
  {
    loading = true;
    notifyListeners();

    await moviesCollection.doc(id).set(item.toJson());

    //refresh the db
    await fetch();
  }

  void delete(String id) async
  {
    loading = true;
    notifyListeners();

    await moviesCollection.doc(id).delete();

    //refresh the db
    await fetch();
  }
  //replaced this
  MovieModel()
  {
    fetch();
  }



  void fetch() async
  {
    //clear any existing data we have gotten previously, to avoid duplicate data
    items.clear();


    //indicate that we are loading
    loading = true;
    notifyListeners(); //tell children to redraw, and they will see that the loading indicator is on

    //get all movies
    var querySnapshot = await moviesCollection.orderBy("title").get();

    //iterate over the movies and add them to the list
    querySnapshot.docs.forEach((doc) {
      //note not using the add(Movie item) function, because we don't want to add them to the db
      var movie = Movie.fromJson(doc.data());
      movie.id = doc.id; //add this line
      items.add(movie);


    });

    void add(Movie item) async
    {
      loading = true;
      notifyListeners();

      await moviesCollection.add(item.toJson());

      //refresh the db
      await fetch();
    }

    void update(String id, Movie item) async
    {
      loading = true;
      notifyListeners();

      await moviesCollection.doc(id).set(item.toJson());

      //refresh the db
      await fetch();
    }

    void delete(String id) async
    {
      loading = true;
      notifyListeners();

      await moviesCollection.doc(id).delete();

      //refresh the db
      await fetch();
    }
    //put this line in to artificially increase the load time, so we can see the loading indicator (when we add it in a few steps time)
    //comment this out when the delay becomes annoying
    await Future.delayed(Duration(seconds: 2));

    //we're done, no longer loading
    loading = false;
    notifyListeners();
  }


}