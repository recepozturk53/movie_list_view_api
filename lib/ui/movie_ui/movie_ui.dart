import 'package:flutter/material.dart';
import 'package:movi_db_api2/model/movie.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetailsThumbnail extends StatelessWidget {
  final String thumbnail;
  final YoutubePlayerController controller;



  const MovieDetailsThumbnail({Key? key, required this.thumbnail,required this.controller})
      : super(key: key);



  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 170,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(thumbnail), fit: BoxFit.cover)),
              ),
              Icon(
                Icons.play_circle_outline,
                size: 100,
                color: Colors.white,
              )

            ],
          ),
          Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xf5f5f5), Color(0xfff5f5f5)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            height: 80,
          ),
        ],
      ),
      onTap: () => {
        showDialogFunc(context, controller)
      },
    );
  }

  showDialogFunc(context, _controller) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              // padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.width * 0.54,
              width: MediaQuery.of(context).size.width * 0.96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Colors.blueAccent,
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );

  }
}

class MovieDetailsExtraPosters extends StatelessWidget {
  final List posters;

  const MovieDetailsExtraPosters({Key? key, required this.posters})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Text(
            "More Movie Posters".toUpperCase(),
            style: TextStyle(fontSize: 14, color: Colors.black26),
          ),
        ),
        Container(
            height: 170,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) => SizedBox(
                width: 8,
              ),
              itemCount: posters.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  showDialogFunc(context, posters[index]);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    height: 160,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(posters[index]),
                            fit: BoxFit.cover)),
                  ),
                ),
              ),
            ))
      ],
    );
  }

  showDialogFunc(context, img) {
    return showDialog(
      context: context,
      builder: (context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              // padding: EdgeInsets.all(5),
              height: MediaQuery.of(context).size.width * 0.54,
              width: MediaQuery.of(context).size.width * 0.96,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                    ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      img,
                      height: MediaQuery.of(context).size.width * 0.54,
                      width: MediaQuery.of(context).size.width * 0.96,
                      fit: BoxFit.cover,
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class MovieDetailsHeaderWithPoster extends StatelessWidget {
  final Movie movie;

  const MovieDetailsHeaderWithPoster({Key? key, required this.movie})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          MoviePoster(poster: movie.poster.toString()),
          SizedBox(
            width: 16,
          ),
          Expanded(child: MovieDetailsHeader(movie: movie))
        ],
      ),
    );
  }
}

class MovieDetailsHeader extends StatelessWidget {
  final Movie movie;

  const MovieDetailsHeader({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "${movie.release_date} . ${movie.vote_average}".toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.w400, color: Colors.cyan),
        ),
        Text(
          movie.title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 32,
          ),
        ),
        Text.rich(TextSpan(
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w300,
            ),
            children: <TextSpan>[
              TextSpan(text: movie.overview),
              TextSpan(
                  text: "More...",
                  style: TextStyle(color: Colors.indigoAccent)),
            ]))
      ],
    );
  }
}

class MovieDetailsCast extends StatelessWidget {
  final Movie movie;

  const MovieDetailsCast({Key? key, required this.movie}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: <Widget>[
          MovieField(field: "Cast", value: movie.casts.join(', ')),
          MovieField(field: "Genres", value: movie.genres.join(', ')),
          MovieField(field: "Directors", value: movie.directors),
        ],
      ),
    );
  }
}

class HorizontalLine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Container(
        height: 0.5,
        color: Colors.grey,
      ),
    );
  }
}

class MovieField extends StatelessWidget {
  final String field;
  final String value;

  const MovieField({Key? key, required this.field, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "$field :",
          style: TextStyle(
              color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w300),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
                color: Colors.black, fontSize: 12, fontWeight: FontWeight.w300),
          ),
        ),
      ],
    );
  }
}

class MoviePoster extends StatelessWidget {
  final String poster;

  const MoviePoster({Key? key, required this.poster}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var borderRadius = BorderRadius.all(Radius.circular(10));
    return Card(
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          width: MediaQuery.of(context).size.width / 4,
          height: 160,
          decoration: BoxDecoration(
              image: DecorationImage(
            image: NetworkImage(poster),
            fit: BoxFit.cover,
          )),
        ),
      ),
    );
  }
}
