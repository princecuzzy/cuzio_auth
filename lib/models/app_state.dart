import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

// we model our app first
@immutable
class AppState {
  final dynamic user;

  AppState({@required this.user});

// default state that can be used outside AppState
  factory AppState.initial() {
    return AppState(user: null);
  }
}
