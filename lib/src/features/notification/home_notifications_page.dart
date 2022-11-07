import 'dart:developer' as developer;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:alnabali_driver/src/features/notification/home_notifications_controller.dart';
import 'package:alnabali_driver/src/features/notification/notif_card.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';

class HomeNotificationsPage extends StatelessWidget {
  const HomeNotificationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 10.h),
          height: 192.h,
          child: Image.asset('assets/images/home_icon.png'),
        ),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(90.w),
              ),
            ),
            child: const NotifListView(),
          ),
        ),
      ],
    );
  }
}

class NotifListView extends ConsumerStatefulWidget {
  const NotifListView({super.key});

  @override
  ConsumerState<NotifListView> createState() => _NotifListViewState();
}

class _NotifListViewState extends ConsumerState<NotifListView> {
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

    return ProgressHUD(
      inAsyncCall: state.isLoading,
      child: notis != null && notis.isNotEmpty
          ? ListView.separated(
              padding: const EdgeInsets.only(top: 30),
              itemCount: notis.length,
              itemBuilder: (BuildContext context, int itemIdx) {
                return NotifCard(
                  info: notis[itemIdx],
                  onPressed: () {},
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const SizedBox(),
            )
          : const SizedBox(),
    );
  }
}
