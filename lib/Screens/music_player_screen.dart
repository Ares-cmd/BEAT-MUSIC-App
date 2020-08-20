import 'dart:io';
import 'dart:ui';
import 'package:flutter_ui_music_player/Screens/Homescreen.dart';
import 'package:just_audio/just_audio.dart';
import 'package:marquee/marquee.dart';

import 'package:flutter/material.dart';
import 'package:flutter_ui_music_player/shared/network.dart';
import 'package:volume/volume.dart';

class MusicPlayerScreen extends StatefulWidget {
  final String id;
  int index;

  MusicPlayerScreen(this.id, this.index);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  bool isplaying = true;
  String stitle = 'Title';
  String thumbnail =
      'https://api.time.com/wp-content/uploads/2019/09/karaoke-mic.jpg';
  String url;
  int cindex;

  Duration _duration = Duration();
  Duration _position = Duration();
  double _sliderVolume = 1.0;
  double _maxvolume = 10.0;
  networkHelper networkhelper = networkHelper();
  int maxVol, currentVol;
  AudioManager audioManager;

  final player = AudioPlayer();

  Future<void> initAudioStreamType() async {
    await Volume.controlVolume(AudioManager.STREAM_MUSIC);
  }

  updateVolumes() async {
    // get Max Volume
    maxVol = await Volume.getMaxVol;
    // get Current Volume
    currentVol = await Volume.getVol;
    setState(() {
      _maxvolume = maxVol.toDouble();
      _sliderVolume = currentVol.toDouble();
    });
  }

  setVol(int i) async {
    await Volume.setVol(i, showVolumeUI: ShowVolumeUI.HIDE);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getnPlaySong(widget.id);
    cindex = widget.index;
    audioManager = AudioManager.STREAM_SYSTEM;
    initAudioStreamType();
    updateVolumes();
  }

  void getnPlaySong(String sid) async {
    var songdata = await networkhelper.getsongdetail(sid);
    url = songdata['url'];
    setState(() {
      stitle = songdata['title'];
      thumbnail = songdata['thumbnail'].toString().replaceAll('\n', '');
    });
    await player.setUrl(url);
    player.play();
    _refreshDataUi();
    _duration = await player.durationFuture;
    setState(() {
      isplaying = true;
    });
    print("now playing");
  }

  _refreshDataUi() {
    Future.delayed(Duration(milliseconds: 100)).then((_) async {
      setState(() {});
      if (player.position.inSeconds.toDouble() ==
              _duration.inSeconds.toDouble() &&
          isplaying) {
        getnPlaySong(networkHelper.songlist[cindex + 1].id);
      }
      if (cindex == networkHelper.songlist.length - 1) {
        await networkhelper.getsongs(cindex + 1, networkHelper.cat ?? "HIN");
      }
      updateVolumes();
      _refreshDataUi();
    });
  }

  _playerSeek() async {
    await player.seek(_position);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildWidgetAlbumCoverBlur(mediaQuery),
          _buildWidgetContainerMusicPlayer(mediaQuery),
        ],
      ),
    );
  }

  Widget _buildWidgetContainerMusicPlayer(MediaQueryData mediaQuery) {
    return Padding(
      padding: EdgeInsets.only(top: mediaQuery.padding.top + 16.0),
      child: Column(
        children: <Widget>[
          _buildWidgetActionAppBar(),
          SizedBox(height: 48.0),
          _buildWidgetPanelMusicPlayer(mediaQuery),
        ],
      ),
    );
  }

  Widget _buildWidgetPanelMusicPlayer(MediaQueryData mediaQuery) {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(48.0),
            topRight: Radius.circular(48.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              SizedBox(height: 36.0),
              _buildWidgetArtistPhoto(mediaQuery),
              SizedBox(height: 60.0),
              _buildWidgetLinearProgressIndicator(),
              SizedBox(height: 4.0),
              _buildWidgetLabelDurationMusic(),
              SizedBox(height: 36.0),
              _buildWidgetMusicInfo(),
              _buildWidgetControlMusicPlayer(),
              _buildWidgetControlVolume(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetControlVolume() {
    return Expanded(
      child: Center(
        child: Row(
          children: <Widget>[
            Icon(
              Icons.volume_mute,
              color: Colors.grey.withOpacity(0.5),
            ),
            Expanded(
              child: Slider(
                max: _maxvolume,
                value: _sliderVolume,
                activeColor: Colors.black,
                inactiveColor: Colors.grey.withOpacity(0.5),
                onChanged: (value) {
                  setState(() {
                    _sliderVolume = value;
                    setVol(value.toInt());
                  });
                },
              ),
            ),
            Icon(
              Icons.volume_up,
              color: Colors.grey.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetControlMusicPlayer() {
    return Expanded(
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (cindex > 0) {
                    getnPlaySong(networkHelper.songlist[cindex - 1].id);
                    setState(() {
                      cindex--;
                    });
                  }
                },
                child: Icon(Icons.fast_rewind),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5),
                ),
              ),
              child: GestureDetector(
                onTap: () async {
                  if (isplaying) {
                    await player.pause();
                    setState(() {
                      isplaying = false;
                      print('Pause');
                    });
                  } else {
                    setState(() {
                      isplaying = true;
                      print('Resume');
                    });
                    await player.play();
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Icon(isplaying ? Icons.pause : Icons.play_arrow),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (cindex < networkHelper.songlist.length - 1) {
                    getnPlaySong(networkHelper.songlist[cindex + 1].id);
                    setState(() {
                      cindex++;
                    });
                  }
                },
                child: Icon(Icons.fast_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWidgetMusicInfo() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 30.0,
            width: MediaQuery.of(context).size.width * 0.80,
            child: Marquee(
              text: stitle,
              velocity: 40,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontFamily: "Campton_Light",
                fontSize: 20.0,
              ),
            ),
          ),
          SizedBox(height: 4.0),
//          Text(
//            "artist",
//            style: TextStyle(
//              fontFamily: "Campton_Light",
//              color: Color(0xFF7D9AFF),
//              fontWeight: FontWeight.w600,
//            ),
//          ),
        ],
      ),
    );
  }

  Widget _buildWidgetLabelDurationMusic() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          "${player.position.inMinutes}:${(player.position.inSeconds.remainder(60))}",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
        Text(
          "${_duration.inMinutes}:${(_duration.inSeconds.remainder(60))}",
          style: TextStyle(
            color: Colors.grey,
            fontSize: 12.0,
          ),
        ),
      ],
    );
  }

  Widget _buildWidgetLinearProgressIndicator() {
    return SizedBox(
      height: 5.0,
      child: Slider(
        activeColor: Colors.brown,
        value: player.position.inSeconds.toDouble() ?? 0,
        min: 0,
        max: _duration.inSeconds.toDouble() ?? 0.00,
        onChanged: (val) {
          setState(() {
            _position = Duration(seconds: val.toInt());
            _playerSeek();
          });
        },
      ),
    );
  }

  Widget _buildWidgetArtistPhoto(MediaQueryData mediaQuery) {
    return Center(
      child: Container(
        width: mediaQuery.size.width / 1.2,
        height: mediaQuery.size.width / 2,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(
            Radius.circular(24.0),
          ),
          image: DecorationImage(
            image: NetworkImage(
              thumbnail,
            ),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  Widget _buildWidgetActionAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () async {
              Navigator.pop(context);
              await player.pause();
            },
            child: Icon(
              Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
              color: Colors.white,
            ),
          ),
          Text(
            "Artist",
            style: TextStyle(
              color: Colors.white,
              fontFamily: "Campton_Light",
              fontWeight: FontWeight.w900,
              fontSize: 16.0,
            ),
          ),
          Icon(
            Icons.info_outline,
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildWidgetAlbumCoverBlur(MediaQueryData mediaQuery) {
    return Container(
      width: double.infinity,
      height: mediaQuery.size.height / 1.8,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
          image: NetworkImage(thumbnail),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.0),
          ),
        ),
      ),
    );
  }
}
