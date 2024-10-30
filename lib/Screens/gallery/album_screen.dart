import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:getwidget/getwidget.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schoolworkspro_app/Screens/gallery/gallery_screen.dart';
import 'package:schoolworkspro_app/Screens/gallery/image_detail.dart';
import 'package:schoolworkspro_app/Screens/gallery/view_photo.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/gallery_response.dart';
import 'package:schoolworkspro_app/services/gallery_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({Key? key}) : super(key: key);

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
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
      body: FutureBuilder<Galleryresponse>(
          future: gallery_response,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.galleries!.isNotEmpty) {
                return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 6.0),
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: snapshot.data!.galleries!.length,
                  itemBuilder: (context, index) {
                    var album = snapshot.data!.galleries![index].slug.toString();

                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Galleryscreen(
                                    data: snapshot.data!.galleries![index],
                                    index: index,
                                album: album,
                                  )),
                        );
                      },
                      child: GFListTile(
                          title: Container(
                            height: 145,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              border: Border.all(
                                color: Colors.grey,
                                width: 0.5,
                              ),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(api_url2 +
                                      "/uploads/gallery/$album/" +
                                      snapshot.data!.galleries![index].media!
                                          .first)),
                            ),
                          ),
                          subTitle: Center(
                            child: Text(
                              snapshot.data!.galleries![index].title.toString(),
                              overflow: TextOverflow.ellipsis,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          )),
                    );
                  },
                );
              } else {
                return Center(
                  child: Column(
                    children: [
                      Image.asset("assets/images/no_content.PNG"),
                      const Text(
                        "No gallery and events available",
                        style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0),
                      ),
                    ],
                  ),
                );
              }
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
    );
  }
}
