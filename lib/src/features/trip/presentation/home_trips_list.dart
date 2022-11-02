import 'package:alnabali_driver/src/features/trip/data/trip_info.dart';
import 'package:flutter/material.dart';

import 'package:alnabali_driver/src/widgets/constants.dart';
import 'package:alnabali_driver/src/widgets/buttons_tabbar.dart';
import 'package:alnabali_driver/src/widgets/trip_card.dart';

enum TripsListType {
  todayTrips,
  pastTrips,
}

class TripsListView extends StatefulWidget {
  final TripsListType listType;

  const TripsListView({
    Key? key,
    required this.listType,
  }) : super(key: key);

  @override
  State<TripsListView> createState() => _TripsListViewState();
}

class _TripsListViewState extends State<TripsListView> {
  String _getTabTextFromID(int id) {
    if (id == 100) {
      return 'All';
    } else {
      return kTripStatusStrings[id];
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    List<int> tabIDArray = [100, 0, 1, 2, 3, 4, 5];
    var tabCount = 7;
    if (widget.listType == TripsListType.pastTrips) {
      tabIDArray = [100, 2, 4, 5];
      tabCount = 4;
    }

    const tabColor = Color(0xFFB3B3B3);

    return DefaultTabController(
      length: tabCount,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                height: 26,
                child: Image.asset('assets/images/home_icon2.png'),
              ),
              ButtonsTabBar(
                backgroundColor: kColorPrimaryBlue,
                unselectedBackgroundColor: Colors.transparent,
                labelStyle: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
                unselectedLabelStyle: const TextStyle(
                  color: tabColor,
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                ),
                borderWidth: 1,
                borderColor: kColorPrimaryBlue,
                unselectedBorderColor: tabColor,
                radius: 100,
                buttonMargin: const EdgeInsets.symmetric(horizontal: 2),
                tabs: tabIDArray
                    .map((t) => Tab(text: _getTabTextFromID(t)))
                    .toList(),
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: List<Widget>.generate(tabIDArray.length, (int index) {
                /// dummy codes for test
                final dummyInfos = [
                  TripInfo(
                    status: TripStatus.started,
                    tripNo: 123455,
                    company: CompanyInfo(
                      companyName: 'MCDONALD\'S',
                      tripName: 'McDonald\'s Morning Trip',
                    ),
                    busNo: '32-145489',
                    passengers: 25,
                    busLine: BusLineInfo(
                      fromTime: DateTime(2022, 10, 8, 16, 0),
                      toTime: DateTime(2022, 10, 10, 16, 30),
                      courseName: 'KHALDA - ALNEYMAT ST.',
                      cityName: 'AMMAN',
                      courseDetail:
                          'AMMAN - ALSWEFIAH - ALNEYMAT ST.AMMAN ALSWEFIAH - AKBETNAT ST',
                    ),
                  ),
                  TripInfo(
                    status: TripStatus.pending,
                    tripNo: 123455,
                    company: CompanyInfo(
                      companyName: 'AMAZON',
                      tripName: 'Amazon Morning Trip',
                    ),
                    busNo: '32-145489',
                    passengers: 25,
                    busLine: BusLineInfo(
                      fromTime: DateTime(2022, 10, 8, 16, 0),
                      toTime: DateTime(2022, 10, 10, 16, 30),
                      courseName: 'KHALDA - ALNEYMAT ST.',
                      cityName: 'AMMAN',
                      courseDetail:
                          'AMMAN - ALSWEFIAH - ALNEYMAT ST.AMMAN ALSWEFIAH - AKBETNAT ST',
                    ),
                  ),
                  TripInfo(
                    status: TripStatus.accepted,
                    tripNo: 123455,
                    company: CompanyInfo(
                      companyName: 'MCDONALD\'S',
                      tripName: 'McDonald\'s Morning Trip',
                    ),
                    busNo: '32-145489',
                    passengers: 25,
                    busLine: BusLineInfo(
                      fromTime: DateTime(2022, 10, 8, 16, 0),
                      toTime: DateTime(2022, 10, 10, 16, 30),
                      courseName: 'KHALDA - ALNEYMAT ST.',
                      cityName: 'AMMAN',
                      courseDetail:
                          'AMMAN - ALSWEFIAH - ALNEYMAT ST.AMMAN ALSWEFIAH - AKBETNAT ST',
                    ),
                  ),
                  TripInfo(
                    status: TripStatus.rejected,
                    tripNo: 123455,
                    company: CompanyInfo(
                      companyName: 'AMAZON',
                      tripName: 'Amazon Morning Trip',
                    ),
                    busNo: '32-145489',
                    passengers: 25,
                    busLine: BusLineInfo(
                      fromTime: DateTime(2022, 10, 8, 16, 0),
                      toTime: DateTime(2022, 10, 10, 16, 30),
                      courseName: 'KHALDA - ALNEYMAT ST.',
                      cityName: 'AMMAN',
                      courseDetail:
                          'AMMAN - ALSWEFIAH - ALNEYMAT ST.AMMAN ALSWEFIAH - AKBETNAT ST',
                    ),
                  ),
                  TripInfo(
                    status: TripStatus.finished,
                    tripNo: 123455,
                    company: CompanyInfo(
                      companyName: 'MCDONALD\'S',
                      tripName: 'McDonald\'s Morning Trip',
                    ),
                    busNo: '32-145489',
                    passengers: 25,
                    busLine: BusLineInfo(
                      fromTime: DateTime(2022, 10, 8, 16, 0),
                      toTime: DateTime(2022, 10, 10, 16, 30),
                      courseName: 'KHALDA - ALNEYMAT ST.',
                      cityName: 'AMMAN',
                      courseDetail:
                          'AMMAN - ALSWEFIAH - ALNEYMAT ST.AMMAN ALSWEFIAH - AKBETNAT ST',
                    ),
                  ),
                  TripInfo(
                    status: TripStatus.canceled,
                    tripNo: 123455,
                    company: CompanyInfo(
                      companyName: 'AMAZON',
                      tripName: 'Amazon Morning Trip',
                    ),
                    busNo: '32-145489',
                    passengers: 25,
                    busLine: BusLineInfo(
                      fromTime: DateTime(2022, 10, 8, 16, 0),
                      toTime: DateTime(2022, 10, 10, 16, 30),
                      courseName: 'KHALDA - ALNEYMAT ST.',
                      cityName: 'AMMAN',
                      courseDetail:
                          'AMMAN - ALSWEFIAH - ALNEYMAT ST.AMMAN ALSWEFIAH - AKBETNAT ST',
                    ),
                  ),
                ];

                return ListView.separated(
                  itemCount: dummyInfos.length,
                  itemBuilder: (BuildContext context, int itemIdx) {
                    return TripCard(
                      info: dummyInfos[itemIdx],
                      onPressed: () {},
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 30),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
