import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:starnest/core/constants/color_palette.dart';
import 'package:starnest/ui/atoms/tinted_asset_image.dart';
import 'package:starnest/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:starnest/features/home/presentation/controllers/home_controller.dart';

// Forward-looking imports for all bottom nav screens
import 'package:starnest/features/home/presentation/pages/home_screen.dart';
import 'package:starnest/features/community/presentation/pages/joined_community_list_screen.dart';
import 'package:starnest/features/search/presentation/pages/search_screen.dart';
import 'package:starnest/features/notification/presentation/pages/notification_screen.dart';
import 'package:starnest/features/profile/presentation/pages/profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  final DashboardController dashboardController = Get.put(
    DashboardController(),
  );
  final HomeController homeController = Get.put(HomeController());

  late TabController _tabController;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: homeController.categories.length,
      vsync: this,
    );
    _tabController.addListener(() {
      final newIndex = _tabController.index;
      if (newIndex >= 0 && newIndex < homeController.categories.length) {
        final newCategory = homeController.categories[newIndex];
        final newColor = homeController.getAccentColorForCategory(newCategory);
        if (homeController.currentAccentColor.value != newColor) {
          homeController.currentAccentColor.value = newColor;
        }
      }
      if (!_tabController.indexIsChanging) {
        homeController.changeCategory(
          homeController.categories[_tabController.index],
        );
      }
    });

    _pages = [
      HomeScreen(tabController: _tabController),
      const JoinedCommunityListScreen(),
      const SearchScreen(),
      NotificationScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  BottomNavigationBarItem _buildIconNavItem(
    String assetPath,
    String selectedAssetPath,
    int index, {
    double width = 24,
    double height = 24,
    int? dominanceThreshold,
  }) {
    bool isSelected = dashboardController.selectedBottomNavIndex.value == index;
    String currentAssetPath = isSelected ? selectedAssetPath : assetPath;
    Color iconColor = isSelected
        ? homeController.currentAccentColor.value
        : homeController.currentAccentColor.value;

    return BottomNavigationBarItem(
      icon: TintedAssetImage(
        assetPath: currentAssetPath,
        targetColor: iconColor,
        dominanceThreshold: dominanceThreshold,
        width: width,
        height: height,
        fit: BoxFit.contain,
      ),
      label: '',
    );
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (dashboardController.selectedBottomNavIndex.value != 0) {
          dashboardController.selectedBottomNavIndex.value = 0;
          return false;
        }
        return true;
      },
      child: Obx(() {
        final isHomeScreen =
            dashboardController.selectedBottomNavIndex.value == 0;
        final Color currentAccentColor =
            homeController.currentAccentColor.value;

        return Scaffold(
          backgroundColor: isHomeScreen
              ? currentAccentColor
              : ColorPalette.white,
          appBar: isHomeScreen
              ? AppBar(
                  backgroundColor: currentAccentColor,
                  elevation: 0,
                  titleSpacing: 16.0,
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/images/black_logo.png',
                        height: 22,
                        width: 22,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Gachibowli\nHyderabad",
                        style: TextStyle(
                          color: ColorPalette.black,
                          fontSize: 15,
                          fontFamily: 'General Sans Variable',
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: Center(
                        child: Image.asset('assets/images/location.png'),
                      ),
                    ),
                  ],
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(48),
                    child: Container(
                      clipBehavior: Clip.none,
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicatorPadding: EdgeInsets.zero,
                        tabAlignment: TabAlignment.start,
                        indicator: const BubbleTabIndicator(),
                        dividerColor: ColorPalette.transparent,
                        labelColor: currentAccentColor,
                        unselectedLabelColor: ColorPalette.black,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.bold,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'General Sans Variable',
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: homeController.categories
                            .map((category) => Tab(text: category, height: 28))
                            .toList(),
                      ),
                    ),
                  ),
                )
              : null,
          body: Container(
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              color: ColorPalette.grey800,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(17),
                topRight: Radius.circular(20),
              ),
            ),
            child: IndexedStack(
              index: dashboardController.selectedBottomNavIndex.value,
              children: _pages,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: ColorPalette.cardBg,
            currentIndex: dashboardController.selectedBottomNavIndex.value,
            onTap: (index) =>
                dashboardController.selectedBottomNavIndex.value = index,
            selectedItemColor: currentAccentColor,
            unselectedItemColor: currentAccentColor,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              _buildIconNavItem(
                "assets/images/home_unselect.png",
                "assets/images/home.png",
                0,
              ),
              _buildIconNavItem(
                "assets/images/chat_unselect.png",
                "assets/images/chat_select.png",
                1,
              ),
              _buildIconNavItem(
                "assets/images/search_ai_unselect.png",
                "assets/images/search_ai_select.png",
                2,
                dominanceThreshold: 30,
              ),
              _buildIconNavItem(
                "assets/images/notification.png",
                "assets/images/notification_select.png",
                3,
              ),
              _buildIconNavItem(
                "assets/images/profile.png",
                "assets/images/people_select.png",
                4,
              ),
            ],
          ),
        );
      }),
    );
  }
}

class BubbleTabIndicator extends Decoration {
  const BubbleTabIndicator();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _BubblePainter(this);
  }
}

class _BubblePainter extends BoxPainter {
  final BubbleTabIndicator decoration;

  _BubblePainter(this.decoration);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Rect baseRect = offset & cfg.size!;
    final Paint paint = Paint()
      ..color = const Color(0xFF0B0B0B)
      ..style = PaintingStyle.fill;

    const double topRadius = 15.0;
    const double concaveRadius = 10.0;
    const double paddingX = 6.0;

    final Rect rect = Rect.fromLTRB(
      baseRect.left - paddingX,
      baseRect.top,
      baseRect.right + paddingX,
      baseRect.bottom + 2.0,
    );

    final Path path = Path();
    path.moveTo(rect.left - concaveRadius, rect.bottom);
    path.quadraticBezierTo(
      rect.left,
      rect.bottom,
      rect.left,
      rect.bottom - concaveRadius,
    );
    path.lineTo(rect.left, rect.top + topRadius);
    path.quadraticBezierTo(
      rect.left,
      rect.top,
      rect.left + topRadius,
      rect.top,
    );
    path.lineTo(rect.right - topRadius, rect.top);
    path.quadraticBezierTo(
      rect.right,
      rect.top,
      rect.right,
      rect.top + topRadius,
    );
    path.lineTo(rect.right, rect.bottom - concaveRadius);
    path.quadraticBezierTo(
      rect.right,
      rect.bottom,
      rect.right + concaveRadius,
      rect.bottom,
    );
    path.lineTo(rect.left - concaveRadius, rect.bottom);
    path.close();

    canvas.drawPath(path, paint);
  }
}
