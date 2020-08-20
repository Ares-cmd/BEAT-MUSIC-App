import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_ui_music_player/shared/network.dart';
import 'music_player_screen.dart';
import 'package:flutter_ui_music_player/model/song_model.dart';

GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

class HomeScreen extends StatefulWidget {
  String kselcatgry;
  HomeScreen(this.kselcatgry);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static int start = 0;
  List<Song> listSong = List();
  networkHelper networkhelper = networkHelper();
  ScrollController _scrollController = ScrollController();
  String thumbnail =
      'https://api.time.com/wp-content/uploads/2019/09/karaoke-mic.jpg';

  @override
  void initState() {
    getSonglist(start);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        getSonglist(start);
        start += 10;
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  void getSonglist(int start) async {
    List<Song> songlist =
        await networkhelper.getsongs(start, widget.kselcatgry);
//    listSong.addAll(songlist);
    listSong = songlist;
    getfirstthumbnail();
    print("song list length ${listSong.length}");
  }

  void getfirstthumbnail() async {
    var fsong = await networkhelper.getsongdetail(listSong[0].id);
    setState(() {
      thumbnail = fsong['thumbnail'].toString().replaceAll('\n', '');
    });
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      key: GlobalKey(),
      body: Stack(
        children: <Widget>[
          _buildWidgetAlbumCover(mediaQuery),
          _buildWidgetActionAppBar(mediaQuery),
          _buildWidgetArtistName(mediaQuery),
          _buildWidgetFloatingActionButton(mediaQuery),
          _buildWidgetListSong(mediaQuery),
        ],
      ),
    );
  }

  Widget _buildWidgetArtistName(MediaQueryData mediaQuery) {
    return SizedBox(
      height: mediaQuery.size.height / 1.8,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Stack(
              children: <Widget>[
                Positioned(
                  child: Text(
                    "Songs",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "CoralPen",
                      fontSize: 72.0,
                    ),
                  ),
                  top: constraints.maxHeight - 100.0,
                ),
                Positioned(
                  child: Text(
                    widget.kselcatgry == "ENG" ? "English" : "Hindi",
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: "CoralPen",
                      fontSize: 72.0,
                    ),
                  ),
                  top: constraints.maxHeight - 140.0,
                ),
                Positioned(
                  child: Text(
                    "Tranding",
                    style: TextStyle(
                      color: Color(0xFF7D9AFF),
                      fontSize: 14.0,
                      fontFamily: "Campton_Light",
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  top: constraints.maxHeight - 160.0,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildWidgetListSong(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20.0,
        top: mediaQuery.size.height / 1.8 + 48.0,
        right: 20.0,
        bottom: mediaQuery.padding.bottom + 16.0,
      ),
      child: Column(
        children: <Widget>[
          _buildWidgetHeaderSong(),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              controller: _scrollController,
              separatorBuilder: (BuildContext context, int index) {
                return Opacity(
                  opacity: 0.5,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Divider(
                      color: Colors.grey,
                    ),
                  ),
                );
              },
              itemCount: listSong.length,
              itemBuilder: (BuildContext context, int index) {
                Song song = listSong[index];

                return GestureDetector(
                  onTap: () {
                    _navigatorToMusicPlayerScreen(song.id, index);
                  },
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          song.title,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontFamily: "Campton_Light",
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        song.duration,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetHeaderSong() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "Popular",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: 24.0,
            fontFamily: "Campton_Light",
          ),
        ),
        Text(
          "Show all",
          style: TextStyle(
            color: Color(0xFF7D9AFF),
            fontWeight: FontWeight.w600,
            fontFamily: "Campton_Light",
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetFloatingActionButton(MediaQueryData mediaQuery) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: EdgeInsets.only(
          top: mediaQuery.size.height / 1.8 - 32.0,
          right: 32.0,
        ),
        child: FloatingActionButton(
          child: Icon(
            Icons.play_arrow,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFF7D9AFF),
          onPressed: () {
            _navigatorToMusicPlayerScreen(listSong[0].id, 0);
          },
        ),
      ),
    );
  }

  void _navigatorToMusicPlayerScreen(String id, int idx) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MusicPlayerScreen(id, idx);
    }));
//    Navigator.of(scaffoldState.currentContext)
//        .push(MaterialPageRoute(builder: (context) {
//      return MusicPlayerScreen(id);
//    }));
  }

  Widget _buildWidgetActionAppBar(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        top: mediaQuery.padding.top + 16.0,
        right: 16.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(
            Icons.menu,
            color: Colors.white,
          ),
          Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetAlbumCover(MediaQueryData mediaQuery) {
    return Container(
      width: double.infinity,
      height: mediaQuery.size.height / 1.8,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(48.0),
        ),
        image: DecorationImage(
          image: NetworkImage(thumbnail),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
