import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../api/api.dart';
import '../../../constants/colors.dart';
import '../../../constants/fonts.dart';
import '../../../constants/text_style.dart';
import '../../../response/verifiedJournal_response.dart';
import 'package:intl/intl.dart';

class SingleJournalCard extends StatelessWidget {
  Journal weekly;
  Function()? onTap;
  String userextension;

  SingleJournalCard(
      {Key? key, required this.weekly, this.onTap, required this.userextension})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.parse(weekly.createdAt.toString());
    now = now.add(const Duration(hours: 5, minutes: 45));
    var formattedTime = DateFormat('yMMMMd').format(now);

    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 2, color: grey_200)),
      height: 260,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              weekly.title ?? "",
              style: w8S15,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                CircleAvatar(
                    radius: 12,
                    backgroundColor:
                        weekly.author!.userImage == null ? Colors.grey : kWhite,
                    child: weekly.author!.userImage != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              '$api_url2/uploads/users/${weekly.author!.userImage ?? ''}',
                              width: 24,
                              height: 24,
                              fit: BoxFit.cover,
                            ),
                          )
                        : const ClipOval()),
                const SizedBox(width: 5),
                Text("${weekly.author!.firstname} ${weekly.author!.lastname}"),
                const Spacer(),
                const Icon(
                  Icons.watch_later_outlined,
                  color: logoTheme,
                ),
                const SizedBox(width: 5),
                Text(formattedTime),
              ],
            ),
            const Divider(
              height: 25,
              thickness: 4,
              color: logoTheme,
            ),
            Text(
              weekly.intro.toString(),
              maxLines: 4,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                textBaseline: TextBaseline.alphabetic,
                children: const [
                  Text(
                    "Read More",
                    style: TextStyle(
                        color: logoTheme,
                        fontWeight: FontWeight.w900,
                        fontSize: 14),
                  ),
                  SizedBox(width: 5),
                  Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                    color: logoTheme,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
