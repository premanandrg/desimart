import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/EmptyWidget.dart';

class DateWidget extends StatelessWidget {
  const DateWidget({Key? key, required this.thisDate, required this.nextDate})
      : super(key: key);

  final DateTime thisDate, nextDate;
  @override
  Widget build(BuildContext context) {
    return thisDate.day != nextDate.day
        ? Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              thisDate.day == DateTime.now().day &&
                      thisDate.month == DateTime.now().month &&
                      thisDate.year == DateTime.now().year
                  ? 'Today'
                  : thisDate.day == DateTime.now().day - 1 &&
                          thisDate.month == DateTime.now().month &&
                          thisDate.year == DateTime.now().year
                      ? 'Yesterday'
                      : DateFormat('d MMM yyy').format(thisDate),
              style: Theme.of(context)
                  .textTheme
                  .caption
                  ?.copyWith(color: Colors.white),
            ),
          )
        : const EmptyWidget();
  }
}
