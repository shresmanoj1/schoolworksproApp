import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/Screens/my_learning/learning_view_model.dart';

import '../../../constants/app_image.dart';
import '../../../constants/text_style.dart';
import '../../../helper/image_from_network.dart';

Widget lecturerIntro(LearningViewModel snapshot, experience) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 12.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Lecturer",
          style: p16.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: ClipRRect(
                child: snapshot.particularModule['moduleLeader']['imageUrl'] ==
                    null ||
                    snapshot.particularModule['moduleLeader']['imageUrl']
                        .isEmpty
                    ? Text(
                  snapshot.particularModule['moduleLeader']['firstname']
                  [0]
                      .toUpperCase() +
                      "" +
                      snapshot.particularModule['moduleLeader']
                      ['lastname'][0]
                          .toUpperCase(),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                )
                    : CachedNetworkImage(
                  height: 130,
                  fit: BoxFit.cover,
                  imageUrl: ImageFromNetwork.fullImageUrl(
                    'uploads/users/${snapshot.particularModule['moduleLeader']['imageUrl']}',
                  ),
                  placeholder: (context, url) =>
                  const Center(child: CupertinoActivityIndicator()),
                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${snapshot.particularModule['moduleLeader']['firstname']} ${snapshot.particularModule['moduleLeader']['lastname']}",
                      style: p14.copyWith(fontWeight: FontWeight.w800),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                  pngBadge,
                                  height: 15,
                                  width: 15,
                                ))),
                        Expanded(
                          flex: 12,
                          child: Text(
                            "Lecturer",
                            style: p14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                  pngExperience,
                                  height: 15,
                                  width: 15,
                                ))),
                        Expanded(
                          flex: 12,
                          child: experience == 0
                              ? Text(
                            " Exp. Joined this year",
                            style: p14,
                            overflow: TextOverflow.ellipsis,
                          )
                              : Text(
                            "Exp. $experience Years",
                            style: p14,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: [
                        const Expanded(
                            flex: 1,
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Icon(
                                  Icons.mail_outline,
                                  size: 17,
                                ))),
                        Expanded(
                            flex: 12,
                            child: Text(
                              snapshot.particularModule['moduleLeader']
                              ['email'] ??
                                  "",
                              style: p14,
                              overflow: TextOverflow.ellipsis,
                            )),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ],
    ),
  );
}
