// import 'package:flutter/material.dart';
// import 'package:photo_view/photo_view.dart';
//
// class ImageDetailGallery extends StatefulWidget {
//   final data;
//   const ImageDetailGallery({Key? key, this.data}) : super(key: key);
//
//   @override
//   _ImageDetailGalleryState createState() => _ImageDetailGalleryState();
// }
//
// class _ImageDetailGalleryState extends State<ImageDetailGallery> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           elevation: 0.0,
//           iconTheme: const IconThemeData(
//             color: Colors.black, //change your color here
//           ),
//           backgroundColor: Colors.white),
//       body: PhotoView(
//         backgroundDecoration: BoxDecoration(
//           color: Colors.white,
//         ),
//         imageProvider: NetworkImage(widget.data),
//       ),
//     );
//   }
// }
