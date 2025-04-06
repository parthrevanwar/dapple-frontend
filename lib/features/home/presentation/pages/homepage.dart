import 'package:dapple/core/cubits/xp/xp_cubit.dart';
import 'package:dapple/core/error/under_construction.dart';
import 'package:dapple/core/routes/app_route_consts.dart';
import 'package:dapple/features/home/presentation/bloc/levels/levels_cubit.dart';
import 'package:dapple/core/widgets/indicators/lives_indicator.dart';
import 'package:dapple/core/widgets/indicators/xp_indicator.dart';
import 'package:dapple/features/home/presentation/bloc/xp_server/xp_server_cubit.dart';
import 'package:dapple/features/home/presentation/new_widgets/learning_card.dart';
import 'package:encrypt_shared_preferences/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/theme/app_palette.dart';
import '../data/levelstatus.dart';
import '../widgets/level_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key, this.isSectionDone});

  bool? isSectionDone;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    if (context.read<LevelsCubit>().state is LevelsInitial) {
      context.read<LevelsCubit>().loadLevels();
      context.read<XpCubit>().updateXpFromServer();
      debugPrint("initState");
    }
  }

  @override
  Widget build(BuildContext context) {
    EncryptedSharedPreferences sharedPreferences = EncryptedSharedPreferences.getInstance();
    final deviceHeight = MediaQuery.of(context).size.height;
    final name = sharedPreferences.getString("userFirstName");
    var xp = sharedPreferences.getInt("userXp");
    if (widget.isSectionDone ?? false) {
      context.read<LevelsCubit>().loadLevels();
      widget.isSectionDone = false;
      context.read<XpServerCubit>().updateXpFromServer();
      xp = sharedPreferences.getInt("userXp");
      setState(() {});
    }
    return Scaffold(
      backgroundColor: AppPalette.primaryColor,
      appBar: AppBar(
        backgroundColor: AppPalette.transparent,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/avatar/1.svg",
              height: 40,
            ),
            const SizedBox(width: 8),
            Text("Hi $name!",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: AppPalette.white)),
            const Spacer(),
            XpIndicator(xp ?? 1469)

            // const SizedBox(width: 8,)
          ],
        ),
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: GestureDetector(
                  onTap: () {
                    // GoRouter.of(context)
                    //     .pushNamed(AppRouteConsts.underConstruction);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(builder: (context) => const UnderConstruction()),
                    // );
                  },
                  child: LearningCard()),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: AppPalette.white, // Background color
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), // Round top-left corner
                  topRight: Radius.circular(20), // Round top-right corner
                ),
              ),
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                child: Text(
                  'Here is a personalized learning plan for you-',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 12),
                ),
              ),
            ),
            BlocBuilder<LevelsCubit, LevelsState>(
              builder: (context, state) {
                if (state is LevelsLoading) {
                  return Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        for (int i = 0; i < 5; i++)
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            direction: ShimmerDirection.ttb,
                            period: Duration(milliseconds: 800),
                            child: Container(
                              margin: EdgeInsets.all(18),
                              height: deviceHeight / 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: AppPalette.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                } else if (state is LevelsLoaded) {
                  final levels = state.levelAndSection.levels;
                  final sections = state.levelAndSection.levels;
                  return Column(
                    children: [
                      for (int i = 0; i < levels.length; i++)
                        Container(
                          decoration: BoxDecoration(
                            // borderRadius: BorderRadius.circular(8),
                            color: AppPalette.white,
                          ),
                          child: LevelWidget(
                            heading: levels[i].name,
                            status: getLevelStatus(
                                state.levelAndSection.completedLevels + 1, i),
                            currentLevel:
                                state.levelAndSection.completedLevels + 1,
                            description: levels[i].description,
                            level: i + 1,
                            currentSection:
                                state.levelAndSection.completedSections + 1,
                            sections: sections[i].sections!,
                          ),
                        ),
                    ],
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      )),
    );
  }

  LevelStatus getLevelStatus(int currentLevel, int index) {
    index++;
    return index < currentLevel
        ? LevelStatus.completed
        : index == currentLevel
            ? LevelStatus.current
            : LevelStatus.locked;
  }
}
