import 'dart:developer' as developer;
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:alnabali_driver/src/constants/app_constants.dart';
import 'package:alnabali_driver/src/constants/app_styles.dart';
import 'package:alnabali_driver/src/features/trip/trip.dart';
import 'package:alnabali_driver/src/features/trip/trip_card.dart';
import 'package:alnabali_driver/src/features/trip/trips_list_controller.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/utils/async_value_ui.dart';
import 'package:alnabali_driver/src/utils/string_hardcoded.dart';
import 'package:alnabali_driver/src/widgets/progress_hud.dart';
import 'package:alnabali_driver/src/widgets/buttons_tabbar.dart';

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

// * ---------------------------------------------------------------------------
// * TripsListView
// * ---------------------------------------------------------------------------

class TripsListView extends ConsumerStatefulWidget {
  const TripsListView({
    Key? key,
    required this.kind,
  }) : super(key: key);

  final TripKind kind;

  @override
  ConsumerState<TripsListView> createState() => _TripsListViewState();
}

class _TripsListViewState extends ConsumerState<TripsListView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrler;

  @override
  void initState() {
    super.initState();

    int length = kTodayFilters.length;
    if (widget.kind == TripKind.past) length = kPastFilters.length;

    _tabCtrler = TabController(length: length, vsync: this);
    // _tabCtrler.addListener(() {
    //   if (_tabCtrler.previousIndex != _tabCtrler.index &&
    //       !_tabCtrler.indexIsChanging) {
    //     setState(() {}); // * rebuild body according to tab change.
    //   }
    // });
  }

  @override
  void dispose() {
    _tabCtrler.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    var filterTabs =
        widget.kind == TripKind.today ? kTodayFilters : kPastFilters;
    const tabColor = Color(0xFFB3B3B3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              height: 60.h,
              child: Image.asset('assets/images/home_icon2.png'),
            ),
            ButtonsTabBar(
              controller: _tabCtrler,
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
                  ref.read(todayTripsFilter.state).state = kTodayFilters[index];
                } else {
                  ref.read(pastTripsFilter.state).state = kPastFilters[index];
                }
              },
            ),
          ],
        ),
        Expanded(
          child: TripsListViewBody(
            kind: widget.kind,
            tabNumber: _tabCtrler.index,
          ),
        ),
      ],
    );
  }
}

// * ---------------------------------------------------------------------------
// * TripsListViewBody
// * ---------------------------------------------------------------------------

class TripsListViewBody extends ConsumerStatefulWidget {
  const TripsListViewBody({
    Key? key,
    required this.kind,
    required this.tabNumber,
  }) : super(key: key);

  final TripKind kind;
  final int tabNumber;

  @override
  ConsumerState<TripsListViewBody> createState() => _TripsTabBodyState();
}

class _TripsTabBodyState extends ConsumerState<TripsListViewBody> {
  @override
  void initState() {
    super.initState();

    if (widget.kind == TripKind.today) {
      ref.read(todayTripListCtrProvider.notifier).doFetchTrips();
    } else {
      ref.read(pastTripListCtrProvider.notifier).doFetchTrips();
    }
  }

  @override
  Widget build(BuildContext context) {
    AsyncValue<void> state;
    TripList? trips;
    if (widget.kind == TripKind.today) {
      ref.listen<AsyncValue>(todayTripListCtrProvider.select((state) => state),
          (_, state) => state.showAlertDialogOnError(context));

      state = ref.watch(todayTripListCtrProvider);
      if (state.isLoading == false) {
        trips = ref.watch(todayFilteredTripsProvider).value;
      }
    } else {
      ref.listen<AsyncValue>(pastTripListCtrProvider.select((state) => state),
          (_, state) => state.showAlertDialogOnError(context));

      state = ref.watch(pastTripListCtrProvider);
      if (state.isLoading == false) {
        trips = ref.watch(pastFilteredTripsProvider).value;
      }
    }

    developer
        .log('TripsBody: type=${widget.kind}, isLoading=${state.isLoading}, '
            'trips=${trips?.length}');

    return ProgressHUD(
      inAsyncCall: state.isLoading,
      child: ListView.separated(
        itemCount: trips?.length ?? 0,
        itemBuilder: (BuildContext context, int itemIdx) {
          return TripCard(
            info: trips!.elementAt(itemIdx),
            onPressed: () {
              context.pushNamed(AppRoute.tripDetail.name);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            SizedBox(height: 90.h),
      ),
    );
  }
}
