enum AppRoute {
  home,
  appList,
  chart,
}

extension AppRouteExtention on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.home:
        return "/";
      case AppRoute.appList:
        return "/appList";
      case AppRoute.chart:
        return "/chart";
    }
  }
}
