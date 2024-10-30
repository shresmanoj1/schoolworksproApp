import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:month_picker_dialog/month_picker_dialog.dart';
import 'package:provider/provider.dart';
import 'package:schoolworkspro_app/Screens/prinicpal/stats_common_view_model.dart';
import 'package:schoolworkspro_app/config/api_response_config.dart';
import 'package:schoolworkspro_app/constants.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:intl/intl.dart';

class ActivityLogsBody extends StatefulWidget {
  final data;
  final initialDate;
  const ActivityLogsBody({Key? key, this.data, this.initialDate})
      : super(key: key);

  @override
  _ActivityLogsBodyState createState() => _ActivityLogsBodyState();
}

class _ActivityLogsBodyState extends State<ActivityLogsBody> {
  final DateRangePickerController _controller = DateRangePickerController();
  final TextEditingController dateController = new TextEditingController();
  var nowsss = DateTime.now();
  PageController pageController = PageController(initialPage: 2022);
  DateTime? selectedDate;
  int? displayedYear;
  late StatsCommonViewModel _provider;

  @override
  void initState() {
    // TODO: implement initState
    var now = DateTime.now();
    selectedDate = DateTime(now.year, now.month);
    displayedYear = selectedDate?.year;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Map<String, dynamic> datas = {"month": now.month, "year": now.year};
      _provider = Provider.of<StatsCommonViewModel>(context, listen: false);
      _provider.fetchactivitylogs(datas, widget.data['username']);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<StatsCommonViewModel>(builder: (context, value, child) {
      return ListView(
        children: [
          Center(
            child: Text(
              "Log Activity",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
          yearMonthPicker(value),
          isLoading(value.logsApiResponse)
              ? Center(
                  child: SpinKitDualRing(
                    color: kPrimaryColor,
                  ),
                )
              : value.monthlyAttendance.isEmpty
                  ? Column(
                      children: [Image.asset("assets/images/no_content.PNG")],
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: value.monthlyAttendance.length,
                      itemBuilder: (context, index) {
                        var datas = value.monthlyAttendance[index];

                        return ListTile(
                          title: Builder(builder: (context) {
                            DateTime start =
                                DateTime.parse(datas.createdAt.toString());

                            start = start
                                .add(const Duration(hours: 5, minutes: 45));

                            var formattedStart =
                                DateFormat('yMMMMd').format(start);

                            return Text("Date: " + formattedStart.toString());
                          }),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              datas.workingHours == null
                                  ? SizedBox()
                                  : Text("Working hours: " +
                                      datas.workingHours.toString()),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemCount: datas.time?.length,
                                itemBuilder: (context, i) {
                                  return Card(
                                    child: ListTile(
                                      subtitle: Builder(builder: (context) {
                                        DateTime start = DateTime.parse(
                                            datas.time![i].punchIn.toString());

                                        start = start.add(const Duration(
                                            hours: 5, minutes: 45));

                                        var formattedStart =
                                            DateFormat('hh mm').format(start);

                                        DateTime end = DateTime.parse(
                                            datas.time![i].punchOut.toString());

                                        end = end.add(const Duration(
                                            hours: 5, minutes: 45));

                                        var formattedend =
                                            DateFormat('hh mm').format(end);
                                        return Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("Punched In: " +
                                                formattedStart.toString()),
                                            Text("Punched Out: " +
                                                formattedend.toString()),
                                          ],
                                        );
                                      }),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        );
                      },
                    )
        ],
      );
    });
  }

  yearMonthPicker(StatsCommonViewModel value) => Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Builder(builder: (context) {
            if (MediaQuery.of(context).orientation == Orientation.portrait) {
              return IntrinsicWidth(
                child: Column(children: [
                  buildHeader(value),
                  Material(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [buildPager(value)],
                    ),
                  )
                ]),
              );
            }
            return IntrinsicHeight(
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildHeader(value),
                    Material(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [buildPager(value)],
                      ),
                    )
                  ]),
            );
          }),
        ],
      );

  buildHeader(StatsCommonViewModel value) {
    return Material(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('${DateFormat.yMMM().format(selectedDate!)}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('${DateFormat.y().format(DateTime(displayedYear!))}',
                    style: TextStyle(color: Colors.white)),
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.keyboard_arrow_up, color: Colors.white),
                      onPressed: () => pageController.animateToPage(
                          displayedYear! - 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut),
                    ),
                    IconButton(
                      icon:
                          Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      onPressed: () => pageController.animateToPage(
                          displayedYear! + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  buildPager(StatsCommonViewModel value) => Container(
        color: Colors.white,
        height: 240.0,
        width: 500.0,
        child: Theme(
            data: Theme.of(context).copyWith(
                buttonTheme: ButtonThemeData(
                    padding: EdgeInsets.all(0.0),
                    shape: CircleBorder(),
                    minWidth: 1.0)),
            child: PageView.builder(
              controller: pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: (index) {
                setState(() {
                  displayedYear = index;
                });
              },
              itemBuilder: (context, year) {
                return GridView.count(
                  padding: EdgeInsets.all(12.0),
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisCount: 5,
                  children: List<int>.generate(12, (i) => i + 1)
                      .map((month) => DateTime(year, month))
                      .map(
                        (date) => Padding(
                          padding: EdgeInsets.all(4.0),
                          child: ElevatedButton(
                            onPressed: () => setState(() {
                              selectedDate = DateTime(date.year, date.month);

                              Map<String, dynamic> datas = {
                                "month": selectedDate?.month,
                                "year": selectedDate?.year
                              };

                              value.fetchactivitylogs(
                                  datas, widget.data['username']);
                            }),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                date.month == selectedDate!.month &&
                                        date.year == selectedDate!.year
                                    ? Colors.orange
                                    : null,
                              ),
                              textStyle: MaterialStateProperty.all(TextStyle(
                                color: date.month == selectedDate!.month &&
                                        date.year == selectedDate!.year
                                    ? Colors.white
                                    : date.month == DateTime.now().month &&
                                            date.year == DateTime.now().year
                                        ? Colors.orange
                                        : null,
                              )),
                            ),
                            // color: date.month == selectedDate!.month &&
                            //         date.year == selectedDate!.year
                            //     ? Colors.orange
                            //     : null,
                            // textColor: date.month == selectedDate!.month &&
                            //         date.year == selectedDate!.year
                            //     ? Colors.white
                            //     : date.month == DateTime.now().month &&
                            //             date.year == DateTime.now().year
                            //         ? Colors.orange
                            //         : null,
                            child: Text(
                              DateFormat.MMM().format(date),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            )),
      );
}
