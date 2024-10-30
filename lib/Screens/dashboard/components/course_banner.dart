// import 'package:flutter/material.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:schoolworkspro_app/constants.dart';
// import 'package:schoolworkspro_app/response/course_response.dart';
// import 'package:schoolworkspro_app/services/course_service.dart';

// class Coursesection extends StatefulWidget {
//   const Coursesection({Key? key}) : super(key: key);

//   @override
//   _CoursesectionState createState() => _CoursesectionState();
// }

// class _CoursesectionState extends State<Coursesection> {
//   late Future<CourseResponse> courseResponse;
//   @override
//   void initState() {
//     // TODO: implement initState
//     getCourse();
//     super.initState();
//   }

//   getCourse() async {
//     courseResponse = CourseService().getCourse();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<CourseResponse>(
//       future: courseResponse,
//       builder: (context, snapshot) {
//         if (snapshot.hasData) {
//           return ListView.builder(
//               shrinkWrap: true,
//               scrollDirection: Axis.horizontal,
//               itemCount: snapshot.data!.courses.length,
//               itemBuilder: (context, index) {
//                 var course = snapshot.data!.courses[index];

//                 return SizedBox(
//                   width: 220,
//                   child: GestureDetector(
//                     onTap: () async {
//                       Navigator.of(context).pushNamed('/coursedetail',
//                           arguments: course.courseSlug);
//                     },
//                     child: Card(
//                       elevation: 3.0,
//                       margin:
//                           const EdgeInsets.only(left: 8, right: 8, bottom: 8),
//                       clipBehavior: Clip.antiAlias,
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(1.0),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 SvgPicture.network(
//                                   'https://api-campus.softwarica.edu.np/uploads/courses/' +
//                                       course.imageUrl,
//                                   height: 128.0,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(course.courseName),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               });
//         } else {
//           return const Center(
//               child: SpinKitDualRing(
//             color: kPrimaryColor,
//           ));
//         }
//       },
//     );
//   }
// }
