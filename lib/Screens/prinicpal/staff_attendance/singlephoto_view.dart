import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class SingleImageViewer extends StatefulWidget {
  final imageIndex;
  final String imageList;

  SingleImageViewer({
    this.imageIndex,
    required this.imageList,
  });

  @override
  _SingleImageViewerState createState() => _SingleImageViewerState();
}

class _SingleImageViewerState extends State<SingleImageViewer> {
  PageController? pageController;
  int? currentIndex;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentIndex = widget.imageIndex;
    pageController = PageController(initialPage: widget.imageIndex);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.clear,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
        centerTitle: true,
        leading: Container(),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            pageController: pageController,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(
                    api_url2 + "/uploads/users/${widget.imageList}"),
                heroAttributes:
                    PhotoViewHeroAttributes(tag: "photo${widget.imageIndex}"),
              );
            },
            onPageChanged: onPageChanged,
            itemCount: 1,
            loadingBuilder: (context, progress) => Center(
              child: Container(
                width: 60.0,
                height: 60.0,
                child: CircularProgressIndicator(
                  value: progress == null
                      ? null
                      : progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!.toInt(),
                ),
              ),
            ),
          ),
          // Positioned(
          //     top: 0.0,
          //
          //     child: IconButton(onPressed: (){}, icon: Icon(Icons.share,color: Colors.white,)))
        ],
      ),
    );
  }
}
