import 'package:dapple/core/theme/app_palette.dart';
import 'package:dapple/core/widgets/indicators/xp_indicator_orange.dart';
import 'package:dapple/core/widgets/text/custom_text_rubik.dart';
import 'package:dapple/features/expert_talk/presentation/bloc/appointments/appointments_cubit.dart';
import 'package:dapple/features/expert_talk/presentation/widgets/appointment_card.dart';
import 'package:dapple/features/expert_talk/presentation/widgets/expert_card.dart';
import 'package:dapple/features/expert_talk/presentation/widgets/no_appointments.dart';
import 'package:dapple/features/expert_talk/presentation/widgets/searchbar.dart';
import 'package:dapple/init_dependencies.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../bloc/experts/experts_cubit.dart';

class ExpertTalkHomeScreen extends StatefulWidget {
  const ExpertTalkHomeScreen({super.key});

  @override
  State<ExpertTalkHomeScreen> createState() => _ExpertTalkHomeScreenState();
}

class _ExpertTalkHomeScreenState extends State<ExpertTalkHomeScreen> {
  @override
  void initState() {
    initExperts();
    initAppointments();
    super.initState();
  }

  void initExperts() async {
    await context.read<ExpertsCubit>().loadExperts();
  }

  void initAppointments() async {
    await context.read<AppointmentsCubit>().loadAppointments();
  }

  @override
  Widget build(BuildContext context) {
    EncryptedSharedPreferences sharedPreferences = serviceLocator();
    var xp = sharedPreferences.getInt("userXp");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppPalette.transparent,
        title: Row(
          children: [
            SizedBox(
              width: 3,
            ),
            CustomTextRubik(
                text: "Talk with Expert",
                weight: FontWeight.w600,
                size: 20,
                color: AppPalette.blackColor),
            Spacer(),
            XpIndicatorOrange(xp ?? 100)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Searchbar(),
            ),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Text(
                  "Upcoming Appointments",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: AppPalette.blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.4),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: SizedBox(
                height: 120,
                child: BlocBuilder<AppointmentsCubit, AppointmentsState>(
                  builder: (context, state) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 20),
                          if (state is AppointmentsLoading)
                            ...List.generate(
                              3,
                                  (i) => Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: 200,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else if (state is AppointmentsLoaded)
                            if (state.appointments.isEmpty)
                              NoAppointments()
                            else
                              ...state.appointments.map(
                                    (appointment) => Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: AppointmentCard(
                                    appointment: appointment,
                                  ),
                                ),
                              )
                          else if (state is AppointmentsError)
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Center(
                                  child: Text("Error loading appointments"),
                                ),
                              ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
              child: Row(
                children: [
                  Text(
                    "Find Experts",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppPalette.blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        height: 1.4),
                  ),
                  // Spacer(),
                  // Text(
                  //   "See all",
                  //   style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  //       color: AppPalette.primaryColor,
                  //       fontSize: 16,
                  //       fontWeight: FontWeight.w500,
                  //       height: 1.6),
                  // ),
                ],
              ),
            ),
            BlocBuilder<ExpertsCubit, ExpertsState>(
              builder: (context, state) {
                if (state is ExpertsLoading) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: List.generate(
                        3, // Generate placeholder shimmer cards
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Container(
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 120,
                                            height: 16,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            width: 180,
                                            height: 12,
                                            color: Colors.white,
                                          ),
                                          SizedBox(height: 8),
                                          Container(
                                            width: 80,
                                            height: 12,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                } else if (state is ExpertsLoaded) {
                  return Column(
                    children: [
                      for (var expert in state.experts)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 6),
                          child: ExpertCard(
                            expert: expert,
                          ),
                        ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                    ],
                  );
                } else if (state is ExpertsError) {
                  return Center(
                    child: Text("Error loading experts"),
                  );
                }
                return Center(
                  child: Text("No experts found"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
