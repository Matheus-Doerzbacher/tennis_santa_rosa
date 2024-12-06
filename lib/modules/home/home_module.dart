import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/home/_views/home_page.dart';

class HomeModule extends Module {
  @override
  void routes(RouteManager r) {
    r.child(Modular.initialRoute, child: (context) => const HomePage());
  }
}
