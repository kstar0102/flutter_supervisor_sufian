import 'package:alnabali_driver/src/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip_card.dart';
import 'package:alnabali_driver/src/features/trip/trip_controller.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';

class TripDetailScreen extends ConsumerStatefulWidget {
  const TripDetailScreen({
    Key? key,
    required this.tripId,
  }) : super(key: key);

  final String tripId;

  @override
  ConsumerState<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends ConsumerState<TripDetailScreen> {
  late Trip info;

  @override
  void initState() {
    super.initState();

    info =
        ref.read(tripControllerProvider.notifier).getTripInfo(widget.tripId)!;
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tripControllerProvider);

    return Scaffold(
      body: Container(
        decoration: kBgDecoration,
        child: Column(
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
                child: ProgressHUD(
                  inAsyncCall: state.isLoading,
                  child: Column(
                    children: [
                      Container(
                        height: 573.h,
                        margin: EdgeInsets.symmetric(vertical: 60.h),
                        child: Image.asset('assets/images/trip_detail.png'),
                      ),
                      TripCard(
                        info: info,
                        onYesNo: (id, targetStatus, extra) {
                          // ? this code duplicated with TripsListView...
                          successCallback(value) {
                            if (value == true) {
                              showOkayDialog(context, info, targetStatus);
                            }

                            // * rebuild detail screen for card update.
                            setState(() {
                              info = ref
                                  .read(tripControllerProvider.notifier)
                                  .getTripInfo(widget.tripId)!;
                            });
                          }

                          ref
                              .read(tripControllerProvider.notifier)
                              .doChangeTrip(info, targetStatus, extra)
                              .then(successCallback);
                        },
                        showDetail: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: SizedBox(
        height: 150.h,
        child: IconButton(
          onPressed: () => context.pop(),
          //iconSize: 89.h,
          icon: Image.asset('assets/images/btn_back.png'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
