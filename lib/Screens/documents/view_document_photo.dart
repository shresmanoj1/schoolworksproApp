import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../api/api.dart';

class ViewFullScreenStudentDocument extends StatefulWidget {
  final String heroTitle;
  final imageIndex;
  // Documents document;
  String? document;

  ViewFullScreenStudentDocument(
      {this.imageIndex,
        required this.document,
        this.heroTitle = "img"});

  @override
  _ViewFullScreenStudentDocumentState createState() => _ViewFullScreenStudentDocumentState();
}

class _ViewFullScreenStudentDocumentState extends State<ViewFullScreenStudentDocument> {
  PageController? pageController;
  int? currentIndex;
  String? date;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // currentIndex = widget.imageIndex;
    // pageController = PageController(initialPage: widget.imageIndex);
    // date = DateFormat('MM-dd-y')
    //     .format(DateTime.parse(widget.document.updatedAt.toString()));
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("$api_url2/uploads/docs/${widget.document}");
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
            // pageController: pageController,
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage("$api_url2/uploads/docs/${widget.document}"),
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