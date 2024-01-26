import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../actions/app_action.dart';
import '../models/app_state.dart';

extension BuildContextEx on BuildContext {
  void dispatch(AppAction action) {
    StoreProvider.of<AppState>(this, listen: false).dispatch(action);
  }
}
