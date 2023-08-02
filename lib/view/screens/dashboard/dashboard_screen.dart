import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/network_info.dart';
import 'package:sixvalley_vendor_app/helper/notification_helper.dart';
import 'package:sixvalley_vendor_app/localization/language_constrants.dart';
import 'package:sixvalley_vendor_app/provider/order_provider.dart';
import 'package:sixvalley_vendor_app/provider/profile_provider.dart';
import 'package:sixvalley_vendor_app/utill/color_resources.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/screens/home/home_page_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/menu/menu_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/order/order_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/refund/refund_screen.dart';

import '../../../provider/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardScreenState createState() => DashboardScreenState();
}

class DashboardScreenState extends State<DashboardScreen>
    with WidgetsBindingObserver {
  void beActive (BuildContext context) async{
    String ? token = await   Provider.of<AuthProvider>(context, listen: false).getUserToken();
    await Provider.of<ProfileProvider>(context, listen: false).updateIsActive(
        true,
        token);
    print("------klaus----init-------- ");
  }
  @override
  didChangeAppLifecycleState(AppLifecycleState state) async {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {

      case AppLifecycleState.resumed:
        print("+-void v-${Provider.of<AuthProvider>(context, listen: false).getUserToken()} --void-+");
        String ? token = await   Provider.of<AuthProvider>(context, listen: false).getUserToken() ;
        print("+-void v--- $token --void-+");
        print("------klaus----resumed-------- ");
        await Provider.of<ProfileProvider>(context, listen: false).updateIsActive(
            true,
            token);

        print("------klaus----resumed-------- ");

        // TODO: Handle this case.
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        print("+-void v-${Provider.of<AuthProvider>(context, listen: false).getUserToken()} --void-+");
        String ? token = await   Provider.of<AuthProvider>(context, listen: false).getUserToken() ;
        print("+-void v--- $token --void-+");
        await Provider.of<ProfileProvider>(context, listen: false).updateIsActive(
            false,
            token);

        print("------klaus----paused--------");

        // TODO: Handle this case.
        break;
    }
  }
  final PageController _pageController = PageController();
  int _pageIndex = 0;
  late List<Widget> _screens;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);

  }
  @override
  void initState() {
    beActive(context);
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Provider.of<ProfileProvider>(context, listen: false).getSellerInfo();

    _screens = [
      HomePageScreen(callback: () {
        setState(() {
          _setPage(1);
        });
      }),
      const OrderScreen(),
      const RefundScreen(),
    ];

    NetworkInfo.checkConnectivity(context);

    var androidInitialize =
        const AndroidInitializationSettings('notification_icon');
    var iOSInitialize = const IOSInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    flutterLocalNotificationsPlugin!.initialize(initializationsSettings);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("onMessage: ${message.data}");
      NotificationHelper.showNotification(
          message, flutterLocalNotificationsPlugin, false);
      Provider.of<OrderProvider>(context, listen: false)
          .getOrderList(context, 1, 'all');
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("onMessageOpenedApp: ${message.data}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_pageIndex != 0) {
          _setPage(0);
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: ColorResources.hintTextColor,
          selectedFontSize: Dimensions.fontSizeSmall,
          unselectedFontSize: Dimensions.fontSizeSmall,
          selectedLabelStyle: robotoBold,
          showUnselectedLabels: true,
          currentIndex: _pageIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            _barItem(Images.home, getTranslated('home', context), 0),
            _barItem(Images.order, getTranslated('my_order', context), 1),
            _barItem(Images.refund, getTranslated('refund', context), 2),
            _barItem(Images.menu, getTranslated('menu', context), 3)
          ],
          onTap: (int index) {
            if (index != 3) {
              setState(() {
                _setPage(index);
              });
            } else {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (con) => const MenuBottomSheet());
            }
          },
        ),
        body: PageView.builder(
          controller: _pageController,
          itemCount: _screens.length,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem _barItem(String icon, String? label, int index) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding:
            const EdgeInsets.only(bottom: Dimensions.paddingSizeExtraSmall),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
                width: index == _pageIndex
                    ? Dimensions.iconSizeLarge
                    : Dimensions.iconSizeMedium,
                child: Image.asset(
                  icon,
                  color: index == _pageIndex
                      ? Theme.of(context).primaryColor
                      : ColorResources.hintTextColor,
                )),
          ],
        ),
      ),
      label: label,
    );
  }

  void _setPage(int pageIndex) {
    setState(() {
      _pageController.jumpToPage(pageIndex);
      _pageIndex = pageIndex;
    });
  }
}
