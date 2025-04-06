import 'package:dapple/core/theme/app_palette.dart';
import 'package:dapple/features/ai_talk_dapple/presentation/pages/ai_talk_homescreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../../features/expert_talk/presentation/pages/expert_talk_home_screen.dart';
import '../../features/home/presentation/pages/homepage.dart';
import '../../features/profile/presentation/pages/profileScreen.dart';

class MainLayoutPage extends StatelessWidget {
  MainLayoutPage({super.key, this.isSectionDone});

  final bool? isSectionDone;

  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(isSectionDone ?? false),
      items: _navBarsItems(),
      navBarHeight: 70,
      padding: const EdgeInsets.only(top: 8),
      backgroundColor: AppPalette.white,
      animationSettings: const NavBarAnimationSettings(
        screenTransitionAnimation: ScreenTransitionAnimationSettings(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          duration: Duration(milliseconds: 200),
          screenTransitionAnimationType: ScreenTransitionAnimationType.slide,
        ),
      ),
      navBarStyle: NavBarStyle.style6,
    );
  }
}

List<Widget> _buildScreens(bool isSectionDone) {
  return [
    HomePage(isSectionDone: isSectionDone,),
    ExpertTalkHomeScreen(),
    AiTalkHomeScreen(),
    ProfileScreen()
  ];
}

List<PersistentBottomNavBarItem> _navBarsItems() {
  return [
    PersistentBottomNavBarItem(
      icon: SvgPicture.asset(
        'assets/navbar_icons/home_active.svg', // You can adjust the size
      ),
      inactiveIcon: SvgPicture.asset(
        'assets/navbar_icons/home.svg', // You can adjust the size
      ),
    ),
    PersistentBottomNavBarItem(
      icon: SvgPicture.asset(
        'assets/navbar_icons/profile_active.svg', // You can adjust the size
      ),
      inactiveIcon: SvgPicture.asset(
        'assets/navbar_icons/profile.svg', // You can adjust the size
      ),
    ),
    PersistentBottomNavBarItem(
      icon: SvgPicture.asset(
        'assets/navbar_icons/message_active.svg', // You can adjust the size
      ),
      inactiveIcon: SvgPicture.asset(
        'assets/navbar_icons/message.svg', // You can adjust the size
      ),
    ),
    PersistentBottomNavBarItem(
      icon: SvgPicture.asset(
        'assets/navbar_icons/goal_active.svg',height: 32, // You can adjust the size
      ),
      inactiveIcon: SvgPicture.asset(
        'assets/navbar_icons/goal.svg',height: 32,  // You can adjust the size
      ),
    ),
  ];
}
