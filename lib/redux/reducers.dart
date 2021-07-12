import 'package:cuzio_store/models/app_state.dart';
import 'package:cuzio_store/redux/actions.dart';

// general reducer . reducers take in both state and action
AppState appReducer(state, action) {
  return AppState(user: userReducer(state.user, action));
}

//user reducer
userReducer(state, action) {
  if (action is GetUserAction) {
//return user from action
    return action.user;
  }
  return state.user;
}
