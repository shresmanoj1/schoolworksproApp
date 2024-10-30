import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/extension/sizebox_ex.dart';

import '../../../config/api_response_config.dart';
import '../../../constants/colors.dart';
import '../../parents/attendance_parent/monthly_attendance_view_model.dart';

class OverallAttendanceScreen extends StatefulWidget {
  final String username;
  const OverallAttendanceScreen({Key? key, required this.username})
      : super(key: key);

  @override
  State<OverallAttendanceScreen> createState() =>
      _OverallAttendanceScreenState();
}

class _OverallAttendanceScreenState extends State<OverallAttendanceScreen> {
  late MonthlyAttendanceViewModel _provider2;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _provider2 =
          Provider.of<MonthlyAttendanceViewModel>(context, listen: false);

      Map<String, dynamic> data = {
        "username": widget.username,
      };
      _provider2.fetchOverallAttendanceReport(data);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MonthlyAttendanceViewModel>(
        builder: (context, monthlyVm, child) {
      return SingleChildScrollView(
        child: isLoading(monthlyVm.overallAttendanceReportApiResponse)
            ? const CupertinoActivityIndicator()
            : Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Student Overall Attendance:",
                      style: TextStyle(fontSize: 16),
                    ),
                    _buildOverallAttendance(
                        present: monthlyVm.overallAttendance.presentSessions.toString(),
                        absent: monthlyVm.overallAttendance.absentSessions.toString(),
                        percentage: monthlyVm.overallAttendance.totalPresentPercentage.toString(),
                        total: monthlyVm.overallAttendance.totalSessions.toString()
                    ),
                    10.sH,
                    const Text(
                      "Student Current Attendance:",
                      style: TextStyle(fontSize: 16),
                    ),
                    _buildOverallAttendance(
                        present: monthlyVm.overallAttendance.currentPresentSessions.toString(),
                        absent: monthlyVm.overallAttendance.currentAbsentSessions.toString(),
                        percentage: monthlyVm.overallAttendance.currentPresentSessions.toString(),
                        total: monthlyVm.overallAttendance.currentTotalSessions.toString()
                    ),
                    50.sH,
                  ],
                ),
              ),
      );
    });
  }

  Widget _buildOverallAttendance({
    required String present,
    required String absent,
    required String percentage,
    required String total}){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 5, vertical: 7),
        decoration: BoxDecoration(
            color: const Color(0xffCE3B7B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300)),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Total Present Sessions: ",
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$present out of $total",
                        style: const TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "Total Absent Sessions: ",
                        style: TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "$absent out of $total",
                        style: const TextStyle(
                            color: white,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text("$percentage%",
                    style: const TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
