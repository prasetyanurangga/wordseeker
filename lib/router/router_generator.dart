import 'package:flutter/material.dart';
import 'package:very_good_slide_puzzle/router/router_name.dart';
import 'package:very_good_slide_puzzle/puzzle/puzzle.dart' deferred as puzzle;
import 'package:very_good_slide_puzzle/landing/landing.dart';
import 'package:very_good_slide_puzzle/setting/setting.dart' deferred as setting;
import 'package:very_good_slide_puzzle/models/models.dart';
import 'package:very_good_slide_puzzle/router/deffered_loader.dart';
import 'package:qlevar_router/qlevar_router.dart';


class RouteGenerator {
  
  static final routes = <QRoute>[
    QRoute(
      name: RoutesName.LANDING_PAGE,
      path: '/', 
      builder: () => LandingPage()
    ),
    QRoute(
      name: RoutesName.SETTING_PAGE,
      path: '/setting',
      builder: () => setting.SettingPage(),
      middleware: [
        DefferedLoader(setting.loadLibrary),
      ],
    ),
    QRoute(
      name: RoutesName.PUZZLE_PAGE,
      path: '/puzzle',
      builder: () => puzzle.PuzzlePage(),
      middleware: [
        DefferedLoader(puzzle.loadLibrary),
      ],
    ),
  ];

}
