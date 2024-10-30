import 'package:flutter/material.dart';
import 'package:schoolworkspro_app/api/api.dart';
import 'package:schoolworkspro_app/response/lecturer/lecturermoduledetail_response.dart';

class LecturerLecturer extends StatefulWidget {
  final data;
  LecturerLecturer({Key? key, this.data}) : super(key: key);

  @override
  State<LecturerLecturer> createState() => _LecturerLecturerState();
}

class _LecturerLecturerState extends State<LecturerLecturer> {
  int? experience;
  @override
  void initState() {
    var datas = widget.data['moduleLeader']['joinDate'];
    DateTime joinedDate = DateTime.parse(datas.toString());
    joinedDate.add(const Duration(hours: 5, minutes: 45));

    var now = DateTime.now();

    experience = now.year - joinedDate.year;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 110,
          child: Card(
            child: ListTile(
              leading: CircleAvatar(
                  radius: 30.0,
                  backgroundColor: Colors.grey,
                  child: widget.data['moduleLeader']['imageUrl'] == null ||
                          widget.data['moduleLeader']['imageUrl'].isEmpty
                      ? Text(
                          widget.data['moduleLeader']['firstname'][0]
                                  .toUpperCase() +
                              "" +
                              widget.data['moduleLeader']['lastname'][0]
                                  .toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        )
                      : ClipOval(
                          child: Image.network(
                            '${api_url2}/uploads/users/' +
                                widget.data['moduleLeader']['imageUrl'],
                            height: 200,
                            width: 200,
                            fit: BoxFit.cover,
                          ),
                        )),
              // : CircleAvatar(
              //     backgroundColor: Colors.grey,
              //     child: _isLoading
              //         ? Text("")
              //         : Image.network(
              //             'https://api-campus.softwarica.edu.np/uploads/users/' +
              //                 user.userImage),
              //   ),

              title: Text(
                widget.data['moduleLeader']['firstname'] +
                    " " +
                    widget.data['moduleLeader']['lastname'],
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              subtitle: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      const Icon(
                        Icons.email,
                        size: 18,
                      ),
                      Text(widget.data['moduleLeader']['email'],
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.timelapse_sharp,
                        size: 18,
                      ),
                      Text("Exp. " + experience.toString() + " Years",
                          style: const TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
