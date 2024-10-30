import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const CustomShimmer.rectangular(
      {this.width = double.infinity, required this.height})
      : this.shapeBorder = const RoundedRectangleBorder();

  const CustomShimmer.circular(
      {this.width = double.infinity,
      required this.height,
      this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.white,
        period: Duration(seconds: 2),
        child: Container(
          width: width,
          height: height,
          decoration: ShapeDecoration(
            color: Colors.grey[400]!,
            shape: shapeBorder,
          ),
        ),
      );
}

class HorizontalLoader extends StatelessWidget {
  const HorizontalLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 200,
              width: 190,
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                physics: const ScrollPhysics(),
                itemBuilder: (context, i) {
                  return Card(
                    elevation: 0.0,
                    margin: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 190.0,
                          width: 185,
                          child: Column(
                            children: [
                              CustomShimmer.rectangular(
                                height: 120,
                                width: 190,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              CustomShimmer.rectangular(
                                height: 10,
                                width: double.infinity,
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              CustomShimmer.rectangular(
                                height: 10,
                                width: double.infinity,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class VerticalLoader extends StatelessWidget {
  const VerticalLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: 5,
          physics: const ScrollPhysics(),
          itemBuilder: (context, i) {
            return const CustomShimmer.rectangular(
              height: 50.0,
              width: double.infinity,
            );
          },
        )
      ],
    );
  }
}


class MultipleVerticalLoader extends StatelessWidget {
  const MultipleVerticalLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: 2,
      itemBuilder: (context, index) {
        return const Padding(
          padding: EdgeInsets.only(bottom: 20),
          child: CustomShimmer.rectangular(
            height: 180,
            width: 100,
          ),
        );
      },
    );
  }
}