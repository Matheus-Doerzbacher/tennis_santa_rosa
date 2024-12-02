import 'dart:developer';

import 'package:flutter/foundation.dart';

void dbPrint(Object data) {
  if (kDebugMode) {
    log(data.toString());
  }
}
