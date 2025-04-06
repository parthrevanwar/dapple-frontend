import 'package:dapple/core/theme/app_palette.dart';
import 'package:dapple/features/expert_talk/domain/entities/appointment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/routes/app_route_consts.dart';

class AppointmentCard extends StatelessWidget {
  const AppointmentCard({super.key, required this.appointment});

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context)
            .pushNamed(AppRouteConsts.appointmentDetails, extra: appointment);
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: AppPalette.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                      image: DecorationImage(
                        image: appointment.imageUrl != null
                            ? NetworkImage(appointment.imageUrl!)
                            : AssetImage("assets/dapple-girl/hi.png"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.expertName,
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(
                                  color: AppPalette.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              appointment.expertRating.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .copyWith(
                                      color: AppPalette.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      height: 1.4),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: SvgPicture.asset(
                                "assets/icons/star.svg",
                                height: 20,
                                width: 20,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    "assets/icons/dots.svg",
                    height: 30,
                    width: 30,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/calender.svg",
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    DateFormat('d MMMM').format(appointment.date),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Color(0xFFC0D4FB),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),
                  Spacer(),
                  SvgPicture.asset(
                    "assets/icons/clock.svg",
                    height: 25,
                    width: 25,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    DateFormat('HH:mm').format(appointment.startTime),
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Color(0xFFC0D4FB),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
