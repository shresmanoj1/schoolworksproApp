import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schoolworkspro_app/Screens/gallery/image_detail.dart';
import 'package:schoolworkspro_app/Screens/gallery/view_photo.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/gallery_response.dart';
import 'package:schoolworkspro_app/services/gallery_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class Galleryscreen extends StatefulWidget {
  final index;
  final data;
  final album;
  const Galleryscreen({Key? key, this.index, this.data, this.album})
      : super(key: key);

  @override
  _GalleryscreenState createState() => _GalleryscreenState();
}

class _GalleryscreenState extends State<Galleryscreen> {
  Future<Galleryresponse>? gallery_response;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    gallery_response = Galleryservice().getgallery();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Gallery and events',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<Galleryresponse>(
                future: gallery_response,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.data.media!.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 6.0,
                                  mainAxisSpacing: 6.0),
                          itemBuilder: (BuildContext context, int i) {
                            print(widget.album);
                            // var album = name.replaceAll(' ', '')
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) {
                                          return ViewPhotos33(
                                            imageIndex: i,
                                            imageList: widget.data.media!,
                                            heroTitle: "image${widget.index}",
                                            slug: widget.album,
                                          );
                                        },
                                        fullscreenDialog: true));
                              },
                              child: Container(
                                child: CachedNetworkImage(
                                  fit: BoxFit.fill,
                                  imageUrl: api_url2 +
                                      "/uploads/gallery/${widget.album}/" +
                                      widget.data.media![i],
                                  placeholder: (context, url) => Container(
                                      child: const Center(
                                          child: CupertinoActivityIndicator())),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            );
                          }),
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else {
                    return const Center(
                      child: SpinKitDualRing(
                        color: kPrimaryColor,
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }
}
