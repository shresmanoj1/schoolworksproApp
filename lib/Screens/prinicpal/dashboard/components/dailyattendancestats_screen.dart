import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/principal_common_view_model.dart';

class DailyAttendanceStatsScreen extends StatefulWidget {
  const DailyAttendanceStatsScreen({Key? key}) : super(key: key);

  @override
  _DailyAttendanceStatsScreenState createState() =>
      _DailyAttendanceStatsScreenState();
}

class _DailyAttendanceStatsScreenState
    extends State<DailyAttendanceStatsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<PrinicpalCommonViewModel>(context, listen: false)
          .fetchdailystats();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PrinicpalCommonViewModel>(builder: (context, value, child) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's attendance",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text("Total students: " + value.totalStudents.toString()),
            Text("Total present students: " + value.totalPresent.toString()),
            Text("Total class taken today: " + value.totalAttendance.toString()),
          ],
        ),
      );
    });
  }
}
