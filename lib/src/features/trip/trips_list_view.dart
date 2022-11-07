import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/features/trip/trip_card.dart';
import 'package:alnabali_driver/src/features/trip/trips_list_view_controller.dart';
import 'package:alnabali_driver/src/features/trip/trips_repository.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:alnabali_driver/src/widgets/buttons_tabbar.dart';

class TripsListView extends ConsumerStatefulWidget {
  final TripKind kind;

  const TripsListView({
    Key? key,
    required this.kind,
  }) : super(key: key);

  @override
  ConsumerState<TripsListView> createState() => _TripsListViewState();
}

class _TripsListViewState extends ConsumerState<TripsListView> {
  @override
  void initState() {
    super.initState();

    if (widget.kind == TripKind.today) {
      ref.read(todayTripsListCtrProvider.notifier).doFetchTrips();
    } else {
      ref.read(pastTripsListCtrProvider.notifier).doFetchTrips();
    }
  }

  String _getTabTitleFromID(TripStatus status) {
    final kTripTabTitles = [
      'All'.hardcoded,
      'Pending'.hardcoded,
      'Accepted'.hardcoded,
      'Rejected'.hardcoded,
      'Started'.hardcoded,
      'Finished'.hardcoded,
      'Canceled'.hardcoded,
    ];
    return kTripTabTitles[status.index];
  }

  // ? JX - i can't think better way than this...
  List<Trip> _getFilteredTrips(List<Trip>? trips, TripStatus filter) {
    if (trips == null) {
      return [];
    } else if (filter == TripStatus.all) {
      return trips;
    }

    return trips.where((t) => t.status == filter).toList();
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<void> state;
    List<Trip>? trips;
    TripStatus filter;
    if (widget.kind == TripKind.today) {
      ref.listen<AsyncValue>(todayTripsListCtrProvider.select((state) => state),
          (_, state) => state.showAlertDialogOnError(context));

      state = ref.watch(todayTripsListCtrProvider);
      trips = ref.watch(todayTripsChangesProvider).value;
      filter = ref.watch(todayTripsFilter);
    } else {
      ref.listen<AsyncValue>(pastTripsListCtrProvider.select((state) => state),
          (_, state) => state.showAlertDialogOnError(context));

      state = ref.watch(pastTripsListCtrProvider);
      trips = ref.watch(pastTripsChangesProvider).value;
      filter = ref.watch(pastTripsFilter);
    }
    final filteredTrips = _getFilteredTrips(trips, filter);
    print('filter=$filter, trips=${filteredTrips.length}');

    const kTodayFilters = [
      TripStatus.all,
      TripStatus.pending,
      TripStatus.accepted,
      TripStatus.rejected,
      TripStatus.started,
      TripStatus.finished,
      TripStatus.canceled,
    ];
    const kPastFilters = [
      TripStatus.all,
      TripStatus.rejected,
      TripStatus.finished,
      TripStatus.canceled,
    ];
    var filterTabs =
        widget.kind == TripKind.today ? kTodayFilters : kPastFilters;
    const tabColor = Color(0xFFB3B3B3);

    return ProgressHUD(
      inAsyncCall: state.isLoading,
      child: DefaultTabController(
        length: filterTabs.length,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.w),
                  height: 60.h,
                  child: Image.asset('assets/images/home_icon2.png'),
                ),
                ButtonsTabBar(
                  duration: 0,
                  backgroundColor: kColorPrimaryBlue,
                  unselectedBackgroundColor: Colors.transparent,
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w500,
                    fontSize: 26.sp,
                  ),
                  unselectedLabelStyle: TextStyle(
                    color: tabColor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w400,
                    fontSize: 26.sp,
                  ),
                  borderWidth: 1,
                  borderColor: kColorPrimaryBlue,
                  unselectedBorderColor: tabColor,
                  radius: 100,
                  height: 70.h,
                  buttonMargin: EdgeInsets.symmetric(horizontal: 4.w),
                  //contentPadding: EdgeInsets.symmetric(horizontal: 8.w),
                  tabs: filterTabs
                      .map((t) => Tab(text: _getTabTitleFromID(t)))
                      .toList(),
                  onTap: (index) {
                    if (widget.kind == TripKind.today) {
                      ref.read(todayTripsFilter.state).state =
                          kTodayFilters[index];
                    } else {
                      ref.read(pastTripsFilter.state).state =
                          kPastFilters[index];
                    }
                  },
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: List<Widget>.generate(filterTabs.length, (int index) {
                  return ListView.separated(
                    itemCount: filteredTrips.length,
                    itemBuilder: (BuildContext context, int itemIdx) {
                      return TripCard(
                        info: filteredTrips[itemIdx],
                        onPressed: () {
                          context.pushNamed(AppRoute.tripDetail.name);
                        },
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        SizedBox(height: 90.h),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
