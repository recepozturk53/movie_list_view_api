import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movi_db_api2/model/movie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import 'movie_ui/movie_ui.dart';

class MovieListView extends StatefulWidget {
  const MovieListView({Key? key}) : super(key: key);

  @override
  _MovieListViewState createState() => _MovieListViewState();
}

class _MovieListViewState extends State<MovieListView> {
  String image_baseurl = ("https://image.tmdb.org/t/p/w500");
  List<Movie> movies = [];
  String adult = "";
  String poster = "";
  String language = "";
  String title = "";
  String overview = "";
  String release_date = "";
  String vote_average = "";
  String id = "";
  int page = 1;
  int value = 0;

  List<String> CreateList(int page) {
    List<String> responses = [
      "https://api.themoviedb.org/3/trending/movie/day?api_key=07f5723af6c9503db9c8ce9493c975ce&language=en-US&watch_region=US&page=" +
          page.toString(),
      "https://api.themoviedb.org/3/discover/movie?api_key=07f5723af6c9503db9c8ce9493c975ce&language=en-US&region=US&vote_average.gte=8&vote_count.gte=10&include_adult=true&sort_by=release_date.desc&page=" +
          page.toString(),
      "https://api.themoviedb.org/3/discover/movie?api_key=07f5723af6c9503db9c8ce9493c975ce&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&with_watch_monetization_types=flatrate&page=" +
          page.toString(),
      //"https://api.themoviedb.org/3/discover/tv?api_key=07f5723af6c9503db9c8ce9493c975ce&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&with_watch_monetization_types=flatrate&page="+page.toString(),
    ];
    return responses;
  }

  void incrementPage() {
    setState(() {
      page == 1 ? page = 2 : page = 1;
      getTemp(CreateList(page)[value]);
    });
  }

  void onSelected(int item) {
    getTemp(CreateList(page)[item]);
    value = item;
  }

  @override
  void initState() {
    CreateList(page);
    getTemp(CreateList(page)[0]);
    /* setState(() {
      filteredMovies=movies;
    });*/
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  print('tiklandı');
                  incrementPage();
                },
                child: Icon(Icons.arrow_forward),
              )),
          PopupMenuButton<int>(
            color: Colors.indigo,
            onSelected: (item) => onSelected(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                value: 0,
                child: Text('Trends'),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text('Most Recent'),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text('Most Popular'),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.blueGrey,
      body: ListView.builder(
          itemCount: movies.length,
          itemBuilder: (BuildContext context, int index) {
            return Stack(children: <Widget>[
              Positioned(child: moviecard(movies[index], context)),
              Positioned(
                  top: 10.0,
                  left: 4.0,
                  child: movieImage(image_baseurl + movies[index].poster)),
            ]);
          }),
    );
  }

  Widget moviecard(Movie movie, BuildContext context) {
    return InkWell(
      child: Container(
        margin: EdgeInsets.only(left: 50.0),
        width: MediaQuery.of(context).size.width,
        height: 120.0,
        child: Card(
          color: Colors.blueGrey.shade900,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 54.0, bottom: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          movie.title.length > 20
                              ? movie.title.substring(0, 20) + "..."
                              : movie.title,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              color: Colors.white),
                        ),
                      ),
                      Text(
                        "Rating: ${movie.vote_average}/10",
                        style: TextStyle(fontSize: 15.0, color: Colors.grey),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        "${movie.release_date}",
                        style: mainTextStyle(),
                      ),
                      Text(
                        movie.language,
                        style: mainTextStyle(),
                      ),
                      Text(
                        "Popularity: " + movie.popularity,
                        style: mainTextStyle(),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieListViewDetails(
                      movie: movie,
                      controller: getVideo(movie),
                    )))
      },
    );
  }

  TextStyle mainTextStyle() {
    return TextStyle(fontSize: 15.0, color: Colors.grey);
  }

  Future<void> getTemp(String path) async {
    http.Response response = await http.get(Uri.parse(path));
    var dataDecoded = jsonDecode(response.body);
    var results = dataDecoded['results'];
    movies.clear();
    setState(() {
      for (var item in results) {
        if (item['backdrop_path'] == null) {
          item['backdrop_path'] = "/hJuDvwzS0SPlsE6MNFOpznQltDZ.jpg";
        }
        movies.add(Movie(
            item['popularity'].toString(),
            image_baseurl + item['backdrop_path'],
            item['original_language'],
            item['title'],
            item['overview'],
            item['release_date'],
            item['vote_average'].toString(),
            item['id'].toString(),
            [],
            //images
            "",
            //video
            [],
            //casts
            [],
            //genres
            "" //directors
            ));
      }
      getDetails();
    });
  }

  Future<void> getDetails() async {
    for (var item in movies) {
      http.Response response = await http.get(Uri.parse(
          'https://api.themoviedb.org/3/movie/${item.id}?api_key=07f5723af6c9503db9c8ce9493c975ce&language=en-US&append_to_response=credits,images,videos&include_image_language=en,null'));
      var dataDecoded = jsonDecode(response.body);

      var images = dataDecoded['images']['backdrops'];
      if (images.length > 10) images = images.sublist(0, 10);
      for (var value in images) {
        String path = image_baseurl + value['file_path'].toString();
        item.images.add(path);
      }

      var videos = dataDecoded['videos']['results'].sublist(0);
      for (var value in videos) {
        String key = value['key'].toString();
        item.videos = key;
      }

      var casts = dataDecoded['credits']['cast'];
      if (casts.length > 10) casts = casts.sublist(0, 10);
      for (var cast in casts) {
        item.casts.add(cast['name']);
      }

      var genres = dataDecoded['genres'];
      for (var genre in genres) {
        item.genres.add(genre['name']);
      }

      var directors = dataDecoded['credits']['crew'];
      var director = directors
          .where((x) => x['job'] == 'Director')
          .map((y) => y['name'])
          .join(', ');
      item.directors = director;
    }
  }

  Widget movieImage(String imageUrl) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
          )),
    );
  }

  YoutubePlayerController getVideo(Movie movie) {
    YoutubePlayerController controller = new YoutubePlayerController(
        initialVideoId: movie.videos, // id youtube video
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ));

    return controller;
  }
}

// new route screen
class MovieListViewDetails extends StatelessWidget {
  final Movie movie;
  final YoutubePlayerController controller;

  const MovieListViewDetails(
      {Key? key, required this.movie, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Movies"),
        backgroundColor: Colors.blueGrey.shade900,
        brightness: Brightness.dark,
      ),
      body: ListView(
        children: <Widget>[
          MovieDetailsThumbnail(
            thumbnail: movie.poster,
            controller: controller,
          ),
          MovieDetailsHeaderWithPoster(movie: movie),
          HorizontalLine(),
          MovieDetailsCast(
            movie: movie,
          ),
          HorizontalLine(),
          MovieDetailsExtraPosters(
            posters: movie.images,
          )
        ],
      ),
    );
  }
}
