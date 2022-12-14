import 'dart:developer' as developer;
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';

import 'package:alnabali_driver/src/features/notification/home_notifications_controller.dart';
import 'package:alnabali_driver/src/features/notification/notif_card.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';

class HomeNotificationsPage extends ConsumerStatefulWidget {
  const HomeNotificationsPage({super.key});

  @override
  ConsumerState<HomeNotificationsPage> createState() =>
      _HomeNotificationsPageState();
}

class _HomeNotificationsPageState extends ConsumerState<HomeNotificationsPage> {
  @override
  void initState() {
    super.initState();

    ref.read(homeNotificationsCtrProvider.notifier).doFetchNotifs();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
        homeNotificationsCtrProvider.select((state) => state),
        (_, state) => state.showAlertDialogOnError(context));

    final state = ref.watch(homeNotificationsCtrProvider);
    final notis = state.value;

    developer.log('NotifListView::build() - state=${state.isLoading}');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(90.w),
        ),
      ),
      child: ProgressHUD(
        inAsyncCall: state.isLoading,
        child: notis != null && notis.isNotEmpty
            ? GroupedListView(
                elements: notis,
                groupBy: (notif) => notif.notifyDate,
                groupSeparatorBuilder: (value) {
                  final now = DateTime.now();
                  final today = DateTime(now.year, now.month, now.day);
                  final yesterday = DateTime(now.year, now.month, now.day - 1);
                  final valueDate =
                      DateTime(value.year, value.month, value.day);

                  final String dateText;
                  if (valueDate == today) {
                    dateText =
                        'Today, ${DateFormat('mm-dd-yyyy').format(value)}';
                  } else if (valueDate == yesterday) {
                    dateText =
                        'Yesterday, ${DateFormat('mm-dd-yyyy').format(value)}';
                  } else {
                    dateText = DateFormat('E, mm-dd-yyyy').format(value);
                  }
                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 30.h, horizontal: 100.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Expanded(child: Divider(color: Colors.black)),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 30.w),
                          child: Text(
                            dateText,
                            style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w500,
                              fontSize: 32.sp,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.black)),
                      ],
                    ),
                  );
                },
                itemBuilder: (context, element) {
                  return GestureDetector(
                    onTap: () {},
                    child: NotifCard(
                      info: element,
                      onPressed: () {},
                    ),
                  );
                },
              )
            // ? ListView.separated(
            //     padding: EdgeInsets.only(top: 100.h),
            //     itemCount: notis.length,
            //     itemBuilder: (BuildContext context, int itemIdx) {
            //       return NotifCard(
            //         info: notis[itemIdx],
            //         onPressed: () {},
            //       );
            //     },
            //     separatorBuilder: (BuildContext context, int index) =>
            //         const SizedBox(child: Text('separator')),
            //   )
            : const SizedBox(),
      ),
    );
  }
}
