// // import 'package:flutter/material.dart';
// //
// // class TestTabScreen extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       home: DefaultTabController(
// //         length: 3, // Number of tabs
// //         child: Scaffold(
// //           body: NestedScrollView(
// //             headerSliverBuilder: (BuildContext context, bool isScrolled) {
// //               return <Widget>[
// //                 SliverAppBar(
// //                   expandedHeight: 200.0,
// //                   floating: false,
// //                   pinned: true,
// //                   flexibleSpace: FlexibleSpaceBar(
// //                     title: Text('Scrollable Tab Bar Example'),
// //                   ),
// //                 ),
// //               ];
// //             },
// //             body: Column(
// //               children: [
// //                 TabBar(
// //                   labelStyle: TextStyle(color: Colors.black),
// //                   indicatorColor: Colors.black,
// //                   tabs: [
// //                     Tab(text: 'Tab 1',),
// //                     Tab(text: 'Tab 2'),
// //                     Tab(text: 'Tab 3'),
// //                   ],
// //                 ),
// //                 Expanded(
// //                   child: TabBarView(
// //                     children: [
// //                       ListView.builder(
// //                         itemCount: 100,
// //                         itemBuilder: (context, index) {
// //                           return ListTile(
// //                             title: Text('Item $index'),
// //                           );
// //                         },
// //                       ),
// //                       // Your content for Tab 2
// //                       Center(child: Text('Tab 2 Content')),
// //                       // Your content for Tab 3
// //                       Center(child: Text('Tab 3 Content')),
// //                     ],
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter/foundation.dart';
//
// @immutable
// class Test3 extends StatefulWidget {
//   Test3({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<Test3> createState() => _Test3State();
// }
//
// class _Test3State extends State<Test3> with TickerProviderStateMixin {
//   late TabController _tabController;
//
//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(vsync: this, length: 10);
//   }
//
//   Widget build(BuildContext context) {
//     final List<String> _tabs = [
//       'Tab 1',
//       'Tab 2',
//       'Tab 2',
//       'Tab 2',
//       'Tab 2',
//       'Tab 2',
//       'Tab 2',
//       'Tab 2',
//       'Tab 2',
//       'Tab 2',
//     ];
//     return DefaultTabController(
//       length: _tabs.length,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Timer::::"),
//           elevation: 0,
//         ),
//         body: NestedScrollView(
//           headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
//             return <Widget>[
//               SliverOverlapAbsorber(
//                 handle:
//                     NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//                 sliver: SliverAppBar(
//                   automaticallyImplyLeading: false,
//                   title: Column(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 2),
//                         color: const Color(0XFFffe9e9),
//                         child: RichText(
//                           text: const TextSpan(
//                               text:
//                                   'This is just for navigation. It will not submit your answer. Click ',
//                               style: TextStyle(
//                                   color: Color(0xfff33066), fontSize: 16),
//                               children: [
//                                 TextSpan(
//                                   text: " Next ",
//                                   style: TextStyle(color: Color(0xfff33066)),
//                                 ),
//                                 TextSpan(
//                                   text: "/ ",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.normal,
//                                       color: Colors.black),
//                                 ),
//                                 TextSpan(
//                                   text: " Previous",
//                                   style: TextStyle(color: Color(0xfff33066)),
//                                 ),
//                                 TextSpan(
//                                   text: " to submit you answer.",
//                                   style: TextStyle(color: Color(0xfff33066)),
//                                 ),
//                               ]),
//                         ),
//                       ),
//                     ],
//                   ),
//                   floating: true,
//                   pinned: true,
//                   snap: false,
//                   primary: true,
//                   expandedHeight: 140,
//                   forceElevated: innerBoxIsScrolled,
//                   bottom: TabBar(
//                     // physics: const NeverScrollableScrollPhysics(),
//                     isScrollable: true,
//                     labelColor: Colors.white,
//                     unselectedLabelColor: Colors.white,
//                     unselectedLabelStyle: const TextStyle(color: Colors.black),
//                     labelPadding: EdgeInsets.zero,
//                     // indicatorSize: TabBarIndicatorSize.tab,
//                     padding: EdgeInsets.zero,
//                     indicator: const BoxDecoration(
//                       border: Border(
//                           bottom:
//                               BorderSide(color: Colors.transparent, width: 0)),
//                     ),
//                     onTap: (int value) {
//                       // setState(() {
//                       //   currentIndex = value;
//                       // });
//                       // subjectiveController.clear();
//                       // viewModel
//                       //     .fetchMyAnswer(viewModel.questionAnswer.exam!
//                       //     .questions![_tabController.index].id
//                       //     .toString())
//                       //     .then((value) {
//                       //   viewModel.questionAnswer.exam!
//                       //       .questions![_tabController.index].options!
//                       //       .asMap()
//                       //       .forEach((key, value) {
//                       //     if (viewModel.myAnswer.answer!.objectiveAnswers!
//                       //         .contains(value)) {
//                       //       common.selectedAnswer.add(key);
//                       //     }
//                       //   });
//                       // });
//                     },
//                     controller: _tabController,
//                     labelStyle: const TextStyle(
//                         color: Colors.white, fontWeight: FontWeight.bold),
//                     tabs: [
//                       ...List.generate(
//                           10,
//                           // viewModel
//                           //     .questionAnswer.exam!.questions!.length,
//                           (index) => Tab(
//                                 child: Padding(
//                                   padding:
//                                       const EdgeInsets.symmetric(horizontal: 5),
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(8),
//                                       color: _tabController.index == index
//                                           ? Colors.blueAccent
//                                           : Colors.black,
//                                     ),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 15, horizontal: 15),
//                                     child: Text("Q.N. ${index + 1}"),
//                                   ),
//                                 ),
//                               ))
//                     ],
//                   ),
//                 ),
//               ),
//             ];
//           },
//           body: TabBarView(
//             controller: _tabController,
//             physics: const NeverScrollableScrollPhysics(),
//             children: _tabs.map((String name) {
//               return SafeArea(
//                 top: false,
//                 bottom: false,
//                 child: Builder(
//                   builder: (BuildContext context) {
//                     return CustomScrollView(
//                       key: PageStorageKey<String>(name),
//                       slivers: <Widget>[
//                         SliverOverlapInjector(
//                           handle:
//                               NestedScrollView.sliverOverlapAbsorberHandleFor(
//                                   context),
//                         ),
//                         const SliverPadding(
//                           padding: EdgeInsets.all(8.0),
//                           sliver: ListTest3(),
//                         ),
//                       ],
//                     );
//                   },
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// @immutable
// class ListTest3 extends StatefulWidget {
//   const ListTest3({
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   State<ListTest3> createState() => _ListTest3State();
// }
//
// class _ListTest3State extends State<ListTest3>
//     with AutomaticKeepAliveClientMixin<ListTest3> {
//   @override
//   bool get wantKeepAlive => true;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   void didUpdateWidget(ListTest3 oldWidget) {
//     super.didUpdateWidget(oldWidget);
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//   }
//
//   @override
//   void dispose() {
//     // Перманетное удаление стейта из дерева
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     super.build(context);
//     return SliverFixedExtentList(
//       itemExtent: 48.0,
//       delegate: SliverChildBuilderDelegate(
//         (BuildContext context, int index) {
//           return ListTile(
//             tileColor: Color((Random().nextDouble() * 0xFFFFFF).toInt() << 0)
//                 .withOpacity(1.0),
//             title: Text('Item $index'),
//           );
//         },
//         childCount: 100,
//       ),
//     );
//   }
// }
