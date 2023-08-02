import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sixvalley_vendor_app/helper/network_info.dart';
import 'package:sixvalley_vendor_app/provider/auth_provider.dart';
import 'package:sixvalley_vendor_app/provider/splash_provider.dart';
import 'package:sixvalley_vendor_app/utill/app_constants.dart';
import 'package:sixvalley_vendor_app/utill/dimensions.dart';
import 'package:sixvalley_vendor_app/utill/images.dart';
import 'package:sixvalley_vendor_app/utill/styles.dart';
import 'package:sixvalley_vendor_app/view/screens/auth/auth_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/dashboard/dashboard_screen.dart';
import 'package:sixvalley_vendor_app/view/screens/splash/widget/splash_painter.dart';

import '../../../helper/check_version/check_version.dart';
import '../../../helper/check_version/updateVersion.dart';

class SplashScreen extends StatefulWidget {
  final int? orderId;

  const SplashScreen({Key? key, this.orderId}) : super(key: key);

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  void _route() async {
    NetworkInfo.checkConnectivity(context);
    final myVersion = await getAppVersion();
    ApiClient apiClient = ApiClient();
    final newVersion = await VersionRepository(apiClient).getVersion();
    List<String> myVersionParts = myVersion.split('.');
    List<String> newVersionParts = newVersion!.split('.');
    double versionD = double.parse('${myVersionParts[0]}.${myVersionParts[1]}');
    double newVersionD =
        double.parse('${newVersionParts[0]}.${newVersionParts[1]}');

    if (kDebugMode) {
      print(
          "myVersion $versionD ************************** newVersionD $newVersionD");
    }
    if (myVersion == newVersion) {
      Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => UpdatePage()));
    } else {
      Provider.of<SplashProvider>(context, listen: false)
          .initConfig()
          .then((bool isSuccess) {
        if (isSuccess) {
          Provider.of<SplashProvider>(context, listen: false)
              .initShippingTypeList(context, '');
          Timer(const Duration(seconds: 1), () {
            if (Provider.of<AuthProvider>(context, listen: false)
                .isLoggedIn()) {
              Provider.of<AuthProvider>(context, listen: false)
                  .updateToken(context);
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const DashboardScreen()));
            } else {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (BuildContext context) => const AuthScreen()));
            }
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _route();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: CustomPaint(
                painter: SplashPainter(),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Hero(
                      tag: 'logo',
                      child: Image.asset(Images.whiteLogo,
                          height: 80.0, fit: BoxFit.cover, width: 80.0)),
                  const SizedBox(
                    height: Dimensions.paddingSizeExtraLarge,
                  ),
                  Text(
                    AppConstants.appName,
                    style: titilliumBold.copyWith(
                        fontSize: Dimensions.fontSizeWallet,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
