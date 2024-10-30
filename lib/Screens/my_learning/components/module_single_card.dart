import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/response/new_learning_response.dart';

import '../../../api/api.dart';
import '../../../config/api_response_config.dart';
import '../../../constants/app_image.dart';
import '../../../constants/colors.dart';
import '../../../constants/text_style.dart';
import '../../../helper/image_from_network.dart';
import '../../../response/mylearning_response.dart';
import '../learning_view_model.dart';

class SingleModuleCard extends StatelessWidget {
  ModuleLearning module;
  Function()? onTap;
  String extension;
  ModuleNew? moduleObj;
  SingleModuleCard(
      {Key? key, required this.module, required this.extension, this.onTap, this.moduleObj})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LearningViewModel>(
      builder: (context , value, child) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(width: 2, color: grey_400)),
          // height: 180,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                module.moduleTitle ?? "",
                style: p15.copyWith(fontWeight: FontWeight.w800,),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10,),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Builder(
                    builder: (context) {
                      return SizedBox(
                        height: 80,
                        width: 100,
                        child: extension == "svg"
                            ? SvgPicture.network(
                                ImageFromNetwork.fullImageUrl(
                                    '/uploads/modules/${module.imageUrl}'),
                                fit: BoxFit.cover,
                              )
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: ImageFromNetwork.fullImageUrl(
                                    '/uploads/modules/${module.imageUrl}'),
                                placeholder: (context, url) => Container(
                                    child: const Center(
                                        child: CupertinoActivityIndicator())),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                      );
                    }
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              pngStairs,
                              height: 25,
                              width: 25,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Level",style: p13.copyWith(fontWeight: FontWeight.w600)
                                  ,  overflow: TextOverflow.visible,
                                  maxLines: 1,),
                                Text(
                                  module.year.toString(),
                                  style: p13,
                                  overflow: TextOverflow.visible,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 5,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(Icons.book_outlined, size: 30, color: black),
                            const SizedBox(
                              width: 5,
                            ),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Lesson Completed",style: p13.copyWith(fontWeight: FontWeight.w600),
                                    // overflow: TextOverflow.visible,
                                    maxLines: 1,
                                  ),
                                  isLoading(value.myNewLearningApiResponse) ? const Text("0/0") :
                                  Builder(
                                    builder: (context) {
                                      return Text(
                                        "${moduleObj?.completedLesson ?? 0}/${moduleObj?.totalLesson ?? 0}",
                                        style: p13,
                                        overflow: TextOverflow.visible,
                                        maxLines: 1,
                                      );
                                    }
                                  ),

                                ],
                              ),
                            ),

                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              isLoading(value.myNewLearningApiResponse) ?  ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: LinearProgressIndicator(
                    minHeight: 10,
                    value: 0,
                    backgroundColor: Colors.grey.shade300,
                    color: const Color(0xFFCF407F)),
              ) :
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${moduleObj?.progress ?? "0"} %",
                    style: p14,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                      minHeight: 10,
                      value: moduleObj?.progress == null ? 0 : double.parse(moduleObj!.progress.toString())/100,
                      backgroundColor: Colors.grey.shade300,
                      color: const Color(0xFFCF407F)),
                ),
              ],),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: onTap,
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                      color: logoTheme,
                      borderRadius: BorderRadius.circular(5)),
                  width: double.infinity,
                  child: Center(
                      child: Text(
                        "Go To Module",
                        textAlign: TextAlign.center,
                        style: p14.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                      )),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
