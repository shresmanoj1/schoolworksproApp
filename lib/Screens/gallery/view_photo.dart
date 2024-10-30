import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

class ViewPhotos33 extends StatefulWidget {
  final String heroTitle;
  final imageIndex;
  final List<dynamic> imageList;
  final slug;
  ViewPhotos33(
      {this.imageIndex, required this.imageList, this.heroTitle = "img",this.slug});

  @override
  _ViewPhotos33State createState() => _ViewPhotos33State();
}

class _ViewPhotos33State extends State<ViewPhotos33> {
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
        title: Text(
          "${currentIndex! + 1} out of ${widget.imageList.length}",
          style: TextStyle(color: Colors.white),
        ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.transparent,
        child: Icon(Icons.share),
        onPressed: () async {
          final uri = Uri.parse("$api_url2/uploads/gallery/${widget.slug}/" +
              widget.imageList[currentIndex!]);
          final res = await http.get(uri);

          final bytes = res.bodyBytes;

          final temp = await getTemporaryDirectory();
          final path = '${temp.path}/image.jpg';

          File(path).writeAsBytesSync(bytes);
          await Share.shareFiles([path],
              text: 'I shared this image using SchoolWorksPro');
        },
      ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            pageController: pageController,
            builder: (BuildContext context, int index) {

              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage("$api_url2/uploads/gallery/${widget.slug}/" +
                    widget.imageList[index]),
                heroAttributes:
                    PhotoViewHeroAttributes(tag: "photo${widget.imageIndex}"),
              );
            },
            onPageChanged: onPageChanged,
            itemCount: widget.imageList.length,
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
