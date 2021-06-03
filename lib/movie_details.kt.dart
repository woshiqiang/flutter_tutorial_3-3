import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'movie.dart';

class MovieDetails extends StatefulWidget
{
  final String id; //this is an id now
  const MovieDetails({Key key, this.id}) : super(key: key);

  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {

  final _formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final yearController = TextEditingController();
  final durationController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {
    print('====================================');
    var movie = Provider.of<MovieModel>(context, listen:false).get(widget.id);


    var adding = movie == null;
    if (!adding) {
      titleController.text = movie.title;
      yearController.text = movie.year.toString();
      durationController.text = movie.duration.toString();
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(adding ? "Add Movie" : "Edit Movie"),
        ),
        body: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  if (adding == false) Text("Movie Index ${widget.id}"), //check out this dart syntax, lets us do an if as part of an argument list
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(labelText: "Title"),
                            controller: titleController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "Year"),
                            controller: yearController,
                          ),
                          TextFormField(
                            decoration: InputDecoration(labelText: "Duration"),
                            controller: durationController,
                          ),
                          ElevatedButton.icon(onPressed: () {
                            if (_formKey.currentState.validate())
                            {
                              if (adding)
                              {
                                movie = Movie();
                              }

                              //update the movie object
                              movie.title = titleController.text;
                              movie.year = int.parse(yearController.text); //good code would validate these
                              movie.duration = double.parse(durationController.text); //good code would validate these

                              //TODO: update the model

                              if (adding)
                                Provider.of<MovieModel>(context, listen:false).add(movie);
                              else
                                Provider.of<MovieModel>(context, listen:false).update(widget.id, movie);


                              //return to previous screen
                              Navigator.pop(context);
                            }
                          }, icon: Icon(Icons.save), label: Text("Save Values"))
                        ],
                      ),
                    ),
                  )
                ]
            )
        )
    );
  }
}

