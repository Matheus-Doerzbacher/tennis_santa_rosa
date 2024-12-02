import 'package:flutter_modular/flutter_modular.dart';
import 'package:tennis_santa_rosa/modules/admin/_view/admin_page.dart';

class AdminModule extends Module {
  @override
  @override
  void routes(RouteManager r) {
    r.child(
      Modular.initialRoute,
      child: (context) => const AdminPage(),
    );
  }
}
