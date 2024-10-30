import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:page_transition/page_transition.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/message_principal/send_message.dart';
import 'package:schoolworkspro_app/Screens/widgets/snack_bar.dart';

import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:schoolworkspro_app/response/get_active_users_response.dart';
import 'package:schoolworkspro_app/response/getalluser_response.dart';
import 'package:schoolworkspro_app/services/getalluser_service.dart';

class SearchUserScreen extends StatefulWidget {
  const SearchUserScreen({
    Key? key,
  }) : super(key: key);

  @override
  _SearchUserScreenState createState() => _SearchUserScreenState();
}

class _SearchUserScreenState extends State<SearchUserScreen> {
  List<Color> _colors = [];
  Future<GetActiveUsernameResponse>? user_response;
  Icon cusIcon = const Icon(Icons.search);
  bool connected = false;
  final TextEditingController _searchController = TextEditingController();
  List<ActiveUser> _listForDisplay = <ActiveUser>[];
  List<ActiveUser> _list = <ActiveUser>[];
  // Future<CourseResponse>? courseResponse;
  Widget cusSearchBar = const Text(
    'Search user',
    style: TextStyle(color: Colors.black),
  );

  @override
  void initState() {
    // TODO: implement initState
    getData();

    // courseResponse = CourseService().getCourse();
    super.initState();
  }

  getData() async {
    final data = await GetAllUserService().getAllUsers();
    print(data.activeUsers!.length);
    for (int i = 0; i < data.activeUsers!.length; i++) {
      List.generate(
          data.activeUsers!.length,
          (index) => _colors.add(
              Colors.primaries[Random().nextInt(Colors.primaries.length)]));
      setState(() {
        _list.add(data.activeUsers![i]);
        _listForDisplay = _list;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    if (this.cusIcon.icon == Icons.search) {
                      this.cusIcon = Icon(
                        Icons.cancel,
                        color: Colors.grey,
                      );
                      this.cusSearchBar = TextField(
                        autofocus: true,
                        textInputAction: TextInputAction.go,
                        controller: _searchController,
                        decoration: const InputDecoration(
                            hintText: 'Search name...',
                            border: InputBorder.none),
                        onChanged: (text) {
                          setState(() {
                            _listForDisplay = _list.where((list) {
                              var itemName = list.firstname!.toLowerCase() +
                                  " " +
                                  list.lastname!.toLowerCase();
                              return itemName.contains(text);
                            }).toList();
                          });
                        },
                      );
                    } else {
                      this.cusIcon = const Icon(Icons.search);

                      _searchController.text = "";
                      _listForDisplay = _list;
                      this.cusSearchBar = const Text(
                        'Search user',
                        style: TextStyle(color: Colors.black),
                      );
                    }
                  });
                },
                icon: cusIcon)
          ],
          elevation: 0.0,
          title: cusSearchBar,
          backgroundColor: Colors.white),
      body: _listForDisplay.isEmpty
          ? const SpinKitDualRing(color: kPrimaryColor)
          : getListView(),
    );
  }

  List<ActiveUser> getListElements() {
    var items = List<ActiveUser>.generate(
        _listForDisplay.length, (counter) => _listForDisplay[counter]);
    return items;
  }

  Widget getListView() {
    var listItems = getListElements();
    var listview = ListView.builder(
        shrinkWrap: true,
        itemCount: listItems.length,
        physics: const ScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              if (listItems[index].username == null) {
                snackThis(
                    context: context,
                    duration: 2,
                    color: Colors.red,
                    content: Text(
                        "You can't send message, ${listItems[index].username} doesn't have username"));
              } else {
                Navigator.push(
                    context,
                    PageTransition(
                        child: SendMessageScreen(data: listItems[index]),
                        type: PageTransitionType.bottomToTop));
              }
            },
            child: Card(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                      leading: CircleAvatar(
                          radius: 18,
                          backgroundColor: _colors.length > 0 ? _colors[index] : Colors.green,
                          child: listItems[index].userImage == null
                              ? Text(
                                  listItems[index].firstname![0].toUpperCase() +
                                      "" +
                                      listItems[index]
                                          .lastname![0]
                                          .toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              : ClipOval(
                                  child: Image.network(
                                    api_url2 +
                                        '/uploads/users/' +
                                        listItems[index].userImage.toString(),
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                                )),
                      title: Text(listItems[index].firstname.toString() +
                          " " +
                          listItems[index].lastname.toString()),
                      subtitle: RichText(
                        text: TextSpan(
                          text: 'username: ',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text:
                                  listItems[index].username.toString(),
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          );
        });
    return listview;
  }
}
