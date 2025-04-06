import 'package:dapple/core/routes/app_route_consts.dart';
import 'package:dapple/features/question/presentation/bloc/results.dart';
import 'package:dapple/features/question/presentation/widgets/data_container.dart';
import 'package:dapple/core/widgets/progress_bar/section_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/buttons/primary_button.dart';

class EndSectionScreen extends StatelessWidget {
  const EndSectionScreen({super.key});


  @override
  Widget build(BuildContext context) {
    int xp = 120;
    int timeTaken = 3000;
    final deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        titleSpacing: 0,
        title: SectionProgressBar(
          backButtonColor: AppPalette.white,
          progressColor: AppPalette.primaryColor,
          bgColor: AppPalette.primaryColorLight,
          progressBar: false,
          livesIndicator: true,
        ),
        automaticallyImplyLeading: false,
        backgroundColor: AppPalette.transparent,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/image_bg.png"),
              fit: BoxFit.cover,
              colorFilter:
                  ColorFilter.mode(AppPalette.primaryColor, BlendMode.color)),
        ),
        child: SafeArea(
          minimum: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: Image.asset(
                "assets/dapple-girl/success.png",
                height: deviceHeight * 2 / 5,
              )),
              Text('SECTION\nCOMPLETED',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      height: 0,
                      color: AppPalette.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w700)),
              const Spacer(
                flex: 1,
              ),
              Row(
                children: [
                  Expanded(
                      child: DataContainer(
                          title: "XP GAINED", subtitle: "$xp")),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: DataContainer(
                          title: "TIME TAKEN",
                          subtitle: "${(timeTaken / 60).toInt()}:${timeTaken % 60}")),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: DataContainer(title: "LESSONS", subtitle: "4")),
                ],
              ),
              const Spacer(
                flex: 2,
              ),
              PrimaryButton(
                  onTap: () {
                    GoRouter.of(context).pushReplacementNamed(
                        AppRouteConsts.mainLayout,
                        extra: true);
                  },
                  text: "START NEXT SECTION",
                  primaryColor: AppPalette.primaryColor,
                  bgColor: Colors.white),
              const SizedBox(
                height: 8,
              )
            ],
          ),
        ),
      ),
    );
  }
}
