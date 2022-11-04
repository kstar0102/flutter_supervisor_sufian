import 'package:alnabali_driver/src/constants/app_sizes.dart';
import 'package:alnabali_driver/src/features/trip/data/trip_info.dart';
import 'package:alnabali_driver/src/routing/app_router.dart';
import 'package:alnabali_driver/src/widgets/trip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class TripDetailScreen extends StatefulWidget {
  const TripDetailScreen({Key? key}) : super(key: key);

  @override
  State<TripDetailScreen> createState() => _TripDetailScreenState();
}

class _TripDetailScreenState extends State<TripDetailScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    final dummyInfo = TripInfo(
      status: TripStatus.pending,
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
      rejectReason: 'I\'m sick today',
    );

    return Scaffold(
      body: Container(
        width: SizeConfig.screenW,
        height: SizeConfig.screenH,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg_normal.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 80,
              child: Image.asset('assets/images/home_icon.png'),
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(36),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      height: 573 * SizeConfig.scaleY,
                      margin: EdgeInsets.symmetric(
                          vertical: 90 * SizeConfig.scaleY),
                      child: Image.asset('assets/images/trip_detail.png'),
                    ),
                    TripCard(
                      info: dummyInfo,
                      onPressed: () {},
                      showDetail: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.h),
        child: SizedBox(
          height: 150.h,
          child: IconButton(
            onPressed: () => context.goNamed(AppRoute.home.name),
            //iconSize: 89.h,
            icon: Image.asset('assets/images/btn_back.png'),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}
